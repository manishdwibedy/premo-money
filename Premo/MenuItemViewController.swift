//
//  MenuItemViewController.swift
//  Premo
//
//  Created by Manish Dwibedy on 6/23/16.
//  Copyright © 2016 Manish Dwibedy. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

// This ViewController would be adding new menu items
class MenuItemViewController: UIViewController {
    @IBOutlet weak var party_type: UISegmentedControl!
    @IBOutlet weak var menu_desc: UITextView!
    @IBOutlet weak var menu_item: UITextField!
    
    // The DB reference
    let db_ref = FIRDatabase.database().reference()

    // The UID representing the current logged in user
    let uid = FIRAuth.auth()?.currentUser?.uid
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /*!
     * @discussion Addition of a new menu item
     * @param sender - add menu button
     */
    @IBAction func addMenu(sender: AnyObject) {
        print(party_type.selectedSegmentIndex)
        
        // The party type
        let type = Constant.party_type[party_type.selectedSegmentIndex]
        
        // Getting the party's first character
        let index = type.startIndex.advancedBy(1)
        
        // Getting the user's menu list
        let _ = self.db_ref.child("user_info/\(uid!)/menu").observeSingleEventOfType(FIRDataEventType.Value, withBlock: { (snapshot) in
            let menu_object = snapshot.value
            var menu_array = [[String: AnyObject]]()
            
            if let dd = menu_object as? [[String: AnyObject]]{
                    menu_array = dd
            }
            let menu = [
                "name": self.menu_item.text!,
                "description" : self.menu_desc.text!,
                "type" : type.substringToIndex(index)
            ]
            menu_array.append(menu)
            
            // Adding a menu item
            self.db_ref.child("user_info/\(self.uid!)/menu").setValue(menu_array)
        })
        
    }
}
