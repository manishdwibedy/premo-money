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

// This View Controller would handle the home page screen
class HomePageViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextViewDelegate {
    
    // The complete menu list
    var menu_list = [[String:String]]()
    
    // The current displayed menu list after filtering
    var filteredRows = [[String:String]]()
    
    // The party type array
    let types = ["H", "S", "I"]
    
    // The DB reference
    let db_ref = FIRDatabase.database().reference()
    
    // The UID representing the current logged in user
    let uid = FIRAuth.auth()?.currentUser?.uid
    
    @IBOutlet weak var userIcon: UIImageView!
    
    /*!
     * @discussion Filtering the menu list based on the selection of the segemented control
     * @param the segmented control
     */
    @IBAction func typeChanged(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex
        {
            case 0:
                // Hybrid party type
                self.getFilteredContent("H")
            case 1:
                // Sativa party type
                self.getFilteredContent("S")
            case 2:
                // Indica party type
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
        
        // Getting the user description and menu items for the current user
        let _ = settingRef.observeEventType(FIRDataEventType.Value, withBlock: { (snapshot) in
            let data = snapshot.value as! [String : AnyObject]
            
            // The current user's data
            let user_data = data[self.uid!]!
            
            // Getting the user description, if available
            if let userDescription = user_data["description"] as? String{
                self.userDescription.text = userDescription
            }
            
            // Getting the user's menu list, if available
            if let menu_list = user_data["menu"] as? [[String:String]]{
                self.menu_list = [[String:String]]()
                for menu in menu_list{
                    let menu_data: [String:String] = [
                        "name" : menu["name"]!,
                        "description" : menu["description"]!,
                        "image" : "image URL",
                        "type": menu["type"]!
                    ]
                    self.menu_list.append(menu_data)
                }
                // By default, showing the Hybrid menu items
                self.getFilteredContent("H")
            }
        })
        
        filteredRows = menu_list
        
        
        userDescription.delegate = self
        
        // Making the user's icon as a circular icon with a black border
        userIcon.layer.borderWidth = 1
        userIcon.layer.masksToBounds = false
        userIcon.layer.borderColor = UIColor.blackColor().CGColor
        userIcon.layer.cornerRadius = userIcon.frame.height/2
        userIcon.clipsToBounds = true
        
        // The empty rows would have no seperators
        tableView.tableFooterView = UIView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Number of sections in the menu list
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    // Number of rows in the menu list
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredRows.count
    }
    
    // Rendering individual row in the menu list
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) ->   UITableViewCell{
        var cell = tableView.dequeueReusableCellWithIdentifier("cell") as! MGSwipeTableCell!
        
        if cell == nil
        {
            cell = MGSwipeTableCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "cell")
        }
        
        // configuring right button in the menu list
        
        cell.rightButtons = [
            // The delete button to remove the menu item
            MGSwipeButton(title: "Delete", backgroundColor: UIColor.redColor(), callback: {
                (sender: MGSwipeTableCell!) -> Bool in
                print("Deleted!")
                
                // Deleting the menu item
                let menu = self.filteredRows[indexPath.row]
                self.deleteMenu(menu["name"]!)
                
                return true
            })
            // The more info button to show more details
            ,MGSwipeButton(title: "More",backgroundColor: UIColor.lightGrayColor(), callback: {
                (sender: MGSwipeTableCell!) -> Bool in
                print("More!")
                return true
            })
        ]
        cell.rightSwipeSettings.transition = MGSwipeTransition.Rotate3D

        let row = indexPath.row
        let party = filteredRows[row]
        
        // Setting the menu's text and details
        cell.textLabel?.text = party["name"]
        cell.detailTextLabel?.text = party["description"]
        return cell
    }
    
    // Handling the selection of the menu items
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let row = indexPath.row
        
        print("Selected the speaker :\(row)")
    }
    
    /*!
     * @discussion Filtering the menu list based on the party type, and then reloading the list
     * @param the party type
     */
    func getFilteredContent(type: String){
        // This list would hold all the filtered rows
        var rows = [[String:String]]()
        
        // By default, hybrid type would show all the rows
        if type == "H"{
            self.filteredRows = self.menu_list
        }
        // Otherwise, should only the 'type' in the list
        else{
            for row in self.menu_list{
                if row["type"] == type{
                    rows.append(row)
                }
            }
            self.filteredRows = rows
        }
        
        // Reloading the data in the list
        tableView.reloadData()
    }
    
    var isEditingDescription = false
    @IBOutlet weak var userDescription: UITextView!
    @IBOutlet weak var descriptionButton: UIButton!
    
    /*!
     * @discussion Handling the editing and saving of the user description
     * @param the button handling the user description's edit & save
     */
    @IBAction func editDescription(sender: AnyObject) {
        // Save the user's description
        if isEditingDescription{
            print("saving..")
            userDescription.editable = false
            userDescription.selectable = false
            self.changeButtonText("Edit")
            
            // Save the user description
            self.saveDescription(userDescription.text)
        }
        // Start editing the user's description
        else{
            print("editing..")
            userDescription.editable = true
            userDescription.selectable = true
            userDescription.selectAll(nil)
            self.changeButtonText("Save")
        }
        isEditingDescription = !isEditingDescription
    }
    
    /*!
     * @discussion Change the description button's title
     * @param the label for the description button
     */
    func changeButtonText(label: String){
        descriptionButton.setTitle(label, forState: .Normal)
    }
    
    /*!
     * @discussion Saving the user description
     * @param the user description
     */
    func saveDescription(description: String){
        self.db_ref.child("user_info/\(uid!)/description").setValue(description)
    }
    
    /*!
     * @discussion Deleting the menu item and also reloading the menu list
     * @param the menu's name to be deleted
     * @return true, if the deletion was successful, otherwise false
     */
    func deleteMenu(menuName: String) -> Bool {
        var deleteCount = 0
        var index = 0
        
        // Looping over the filtered menu
        for menu in self.filteredRows{
            // If the menu was found
            if menu["name"] == menuName{
                self.filteredRows.removeAtIndex(index)
                deleteCount += 1
                break
            }
            index += 1
        }
        
        index = 0
        // Looping over the filtered menu
        for menu in self.menu_list{
            // If the menu was found
            if menu["name"] == menuName{
                self.menu_list.removeAtIndex(index)
                deleteCount += 1
                break
            }
            index += 1
        }
        
        // If the menu was found in both the filtered menu list and complete menu list, deleting the menu
        // Otherwise, returning from the method
        if deleteCount == 2{
            
            // Updating the menu list
            self.db_ref.child("user_info/\(uid!)/menu").setValue(self.menu_list)
            tableView.reloadData()
            return true
        }
        else{
            return false
        }
    }
}
