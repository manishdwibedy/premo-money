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
        var menu_list = [[String:String]]()
        let menu = [
            "item": self.menu_item.text!,
            "desc" : self.menu_desc.text!,
            "type" : type.substringToIndex(index)
        ]
        menu_list.append(menu)
        self.db_ref.child("user_info/\(uid!)/menu").setValue(menu_list)
    }
}
