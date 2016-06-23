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

class HomePageViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextViewDelegate {
    var parties = [[String:String]]()
    var filteredRows = [[String:String]]()
    let partyCount = 10
    let types = ["I", "H", "S"]
    let db_ref = FIRDatabase.database().reference()
    let uid = FIRAuth.auth()?.currentUser?.uid
    
    @IBAction func typeChanged(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex
        {
            case 0:
                self.getFilteredContent("I")
            case 1:
                self.getFilteredContent("S")
            case 2:
                self.getFilteredContent("H")
            default:
                break
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        
        for index in Array(1...self.partyCount){
            let type = Int(arc4random_uniform(3))

            let party: [String:String] = [
                "name" : "Party No. \(index)",
                "description" : "Party Description for Party No. \(index)",
                "image" : "image URL",
                "type": self.types[type]
            ]
            parties.append(party)
        }
        filteredRows = parties
        
        // By default, get Indigo
        getFilteredContent("I")
        
        userDescription.delegate = self
        
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
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
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
        
        for row in self.parties{
            if row["type"] == type{
                rows.append(row)
            }
        }
        self.filteredRows = rows
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
}
