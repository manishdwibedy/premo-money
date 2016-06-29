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

class MenuItemViewController: UIViewController {
    @IBOutlet weak var party_type: UISegmentedControl!
    @IBOutlet weak var menu_desc: UITextView!
    @IBOutlet weak var menu_item: UITextField!
    
    let db_ref = FIRDatabase.database().reference()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    @IBAction func addMenu(sender: AnyObject) {
        print(party_type.selectedSegmentIndex)
        
        let type = Constant.party_type[party_type.selectedSegmentIndex]
        let index = type.startIndex.advancedBy(1)
        
        let uid = FIRAuth.auth()?.currentUser?.uid
        
        let _ = self.db_ref.child("user_info/\(uid!)/menu").observeSingleEventOfType(FIRDataEventType.Value, withBlock: { (snapshot) in
            let menu_object = snapshot.value
            var menu_array = [[String: AnyObject]]()
            
            if let dd = menu_object as? [[String: AnyObject]]{
                    menu_array = dd
            }
//            if let menu_try = menu_object as! [[String : AnyObject]]{
//                menu_array = menu_try
//            }
            let menu = [
                "name": self.menu_item.text!,
                "description" : self.menu_desc.text!,
                "type" : type.substringToIndex(index)
            ]
            menu_array.append(menu)
            
            self.db_ref.child("user_info/\(uid!)/menu").setValue(menu_array)

//            
//            print(user_data)
//            self.dob.text = user_data["dob"]!! as? String
//            self.address.text = user_data["address"]!! as? String
//            self.username.text = user_data["username"]!! as? String
        })
        
    }
}
