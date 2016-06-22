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

class SettingsViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var dob: UITextField!
    @IBOutlet weak var address: UITextView!
    @IBOutlet weak var datepicker: UIDatePicker!
    
    let db_ref = FIRDatabase.database().reference()
    let uid = FIRAuth.auth()?.currentUser?.uid
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        
        let settingRef = db_ref.child("user_info")

        let _ = settingRef.observeEventType(FIRDataEventType.Value, withBlock: { (snapshot) in
            let data = snapshot.value as! [String : AnyObject]
            
            let user_data = data[self.uid!]!
            
            print(user_data)
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        address.setContentOffset(CGPointZero, animated: false)
    }
    @IBAction func logout(sender: AnyObject) {
        try! FIRAuth.auth()!.signOut()
        print("the user has logged out")
        self.performSegueWithIdentifier("logoutUser", sender: sender)
    }
    @IBAction func deleteUser(sender: AnyObject) {
        try! FIRAuth.auth()!.signOut()
        print("the user has logged out")
        
        // Have to delete the user as well.
        self.performSegueWithIdentifier("logoutUser", sender: sender)
    }
    
    @IBAction func saveSettings(sender: UIBarButtonItem) {
        let user_data = [
            "username": username.text!,
            "dob" : dob.text!,
            "address": address.text!
        ]
        //db_ref.child("user_info").child(uid!).setValue(user_data)
        Util.getCoordinates(user_data, uid: uid!, db_ref: db_ref)
        
    }
}
