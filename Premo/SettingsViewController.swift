//
//  SettingsViewController.swift
//  Premo
//
//  Created by Manish Dwibedy on 6/20/16.
//  Copyright © 2016 Manish Dwibedy. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

// This ViewController would handle the settings screen
class SettingsViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var dob: UITextField!
    @IBOutlet weak var address: UITextView!
    @IBOutlet weak var datepicker: UIDatePicker!
    
    // The DB reference
    let db_ref = FIRDatabase.database().reference()
    
    // The UID representing the current logged in user
    let uid = FIRAuth.auth()?.currentUser?.uid
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        
        // Getting the user description and menu items for the current user
        let userInfo = db_ref.child("user_info")

        let _ = userInfo.observeEventType(FIRDataEventType.Value, withBlock: { (snapshot) in
            let data = snapshot.value as! [String : AnyObject]
            
            // The current user's data
            let user_data = data[self.uid!]!
            
            print(user_data)
            
            // Getting the user's dob, address and username
            self.dob.text = user_data["dob"]!! as? String
            self.address.text = user_data["address"]!! as? String
            self.username.text = user_data["username"]!! as? String
        })
        
        dob.delegate = self
        username.text = "manish.dwibedy"
        dob.text = "April 17, 1989"
        address.text = "2656 Ellandale Pl.\n Apt #8\n Los Angeles, CA 90007 "
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool{
        // Would be fixing the bug, soon
        // datepicker.alpha = 1
        return true
    }
    
    /*!
     * @discussion This method would scroll the user description text view to the very top
     */
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        address.setContentOffset(CGPointZero, animated: false)
    }
    
    /*!
     * @discussion Logging out the user
     * @param logout button
     */
    @IBAction func logout(sender: AnyObject) {
        // Logging out the current user
        try! FIRAuth.auth()!.signOut()
        print("the user has logged out")
        
        // Moving to the registration screen
        self.performSegueWithIdentifier("logoutUser", sender: sender)
    }
    
    /*!
     * @discussion Logging out the user
     * @param logout button
     */
    @IBAction func deleteUser(sender: AnyObject) {
        try! FIRAuth.auth()!.signOut()
        print("the user has logged out")
        
        // Have to delete the user as well.
        self.performSegueWithIdentifier("logoutUser", sender: sender)
    }
    
    /*!
     * @discussion Saving the user's information
     * @param save button
     */
    @IBAction func saveSettings(sender: UIBarButtonItem) {
        self.db_ref.child("user_info/\(uid!)/username").setValue(username.text!)
        self.db_ref.child("user_info/\(uid!)/dob").setValue(dob.text!)
        self.db_ref.child("user_info/\(uid!)/address").setValue(address.text!)
    }
}
