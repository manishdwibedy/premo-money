//
//  HomePageViewController.swift
//  Premo
//
//  Created by Manish Dwibedy on 6/17/16.
//  Copyright © 2016 Manish Dwibedy. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import MGSwipeTableCell

class HomePageViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextViewDelegate {
    var menu_list = [[String:String]]()
    var filteredRows = [[String:String]]()
    let partyCount = 10
    let types = ["H", "S", "I"]
    let db_ref = FIRDatabase.database().reference()
    let uid = FIRAuth.auth()?.currentUser?.uid
    @IBOutlet weak var userIcon: UIImageView!
    
    @IBAction func typeChanged(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex
        {
            case 0:
                self.getFilteredContent("H")
            case 1:
                self.getFilteredContent("S")
            case 2:
                self.getFilteredContent("I")
            default:
                break
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        
        let settingRef = db_ref.child("user_info")
        
        let _ = settingRef.observeEventType(FIRDataEventType.Value, withBlock: { (snapshot) in
            let data = snapshot.value as! [String : AnyObject]
            
            let user_data = data[self.uid!]!
            
            print(user_data)
            let user_description = user_data["description"] as! String
            self.userDescription.text = user_description
            
            if let menu_list = user_data["menu"] as? [[String:String]]{
                for menu in menu_list{
                    let menu_data: [String:String] = [
                        "name" : menu["item"]!,
                        "description" : menu["desc"]!,
                        "image" : "image URL",
                        "type": menu["type"]!
                    ]
                    self.menu_list.append(menu_data)
                }
                // By default, get Hybrid
                self.getFilteredContent("H")
                
            }
            
        })
        
        filteredRows = menu_list
        
        
        userDescription.delegate = self
        
        let userInfoRef = db_ref.child("user_info")
        
        let _ = userInfoRef.observeEventType(FIRDataEventType.Value, withBlock: { (snapshot) in
            let data = snapshot.value as! [String : AnyObject]
            
            let user_data = data[self.uid!]!
            
            if let user_description = user_data["description"]! as? String{
                self.userDescription.text = user_description
            }
            
        })
        
        userIcon.layer.borderWidth = 1
        userIcon.layer.masksToBounds = false
        userIcon.layer.borderColor = UIColor.blackColor().CGColor
        userIcon.layer.cornerRadius = userIcon.frame.height/2
        userIcon.clipsToBounds = true
        
        tableView.tableFooterView = UIView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Number of sections
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    // Number of rows
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredRows.count
    }
    
    // Rendering individual cell
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) ->   UITableViewCell{
        var cell = tableView.dequeueReusableCellWithIdentifier("cell") as! MGSwipeTableCell!
        
        if cell == nil
        {
            cell = MGSwipeTableCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "cell")
        }
        
        //configure right buttons
        cell.rightButtons = [MGSwipeButton(title: "Delete", backgroundColor: UIColor.redColor(), callback: {
            (sender: MGSwipeTableCell!) -> Bool in
            print("Deleted!")
            let menu = self.filteredRows[indexPath.row]
            self.deleteMenu(menu["name"]!)
            return true
        })
            ,MGSwipeButton(title: "More",backgroundColor: UIColor.lightGrayColor(), callback: {
                (sender: MGSwipeTableCell!) -> Bool in
                print("More!")
                return true
            })]
        cell.rightSwipeSettings.transition = MGSwipeTransition.Rotate3D

        let row = indexPath.row
        let party = filteredRows[row]
        cell.textLabel?.text = party["name"]
        cell.detailTextLabel?.text = party["description"]
        return cell
    }
    
    // Selecting individual cell
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let row = indexPath.row
        
        print("Selected the speaker :\(row)")
    }
    
    func getFilteredContent(type: String){
        var rows = [[String:String]]()
        
        if type == "H"{
            self.filteredRows = self.menu_list
        }
        else{
            for row in self.menu_list{
                if row["type"] == type{
                    rows.append(row)
                }
            }
            self.filteredRows = rows
        }
        tableView.reloadData()
    }
    
    var isEditingDescription = false
    @IBOutlet weak var userDescription: UITextView!
    @IBOutlet weak var descriptionButton: UIButton!
    @IBAction func editDescription(sender: AnyObject) {
        // Save the description
        if isEditingDescription{
            print("saving..")
            userDescription.editable = false
            userDescription.selectable = false
            self.changeButtonText("Edit")
            self.saveDescription(userDescription.text)
        }
        // Start editing
        else{
            print("editing..")
            userDescription.editable = true
            userDescription.selectable = true
            userDescription.selectAll(nil)
            self.changeButtonText("Save")
        }
        isEditingDescription = !isEditingDescription
    }
    
    func changeButtonText(label: String){
        descriptionButton.setTitle(label, forState: .Normal)
    }
    
    func saveDescription(description: String){
        self.db_ref.child("user_info/\(uid!)/description").setValue(description)
    }
    @IBAction func addMenuItem(sender: AnyObject) {
        let category = Int(arc4random_uniform(3))
        
        let party: [String:String] = [
            "name" : "Party No. \(menu_list.count + 1)",
            "description" : "Party Description for Party No. \(menu_list.count + 1)",
            "image" : "image URL",
            "type": self.types[category]
        ]
        menu_list.append(party)
        tableView.reloadData()
    }
    
    func deleteMenu(menuName: String) -> Bool {
        var deleteCount = 0
        var index = 0
        for menu in self.filteredRows{
            if menu["name"] == menuName{
                self.filteredRows.removeAtIndex(index)
                deleteCount += 1
            }
            index += 1
        }
        
        index = 0
        for menu in self.menu_list{
            if menu["name"] == menuName{
                self.menu_list.removeAtIndex(index)
                deleteCount += 1
                self.db_ref.child("user_info/\(uid!)/menu/\(index - 1)").removeValue()
            }
            index += 1
        }
        if deleteCount == 2{
            tableView.reloadData()
            return true
        }
        else{
            return false
        }
    }
}
