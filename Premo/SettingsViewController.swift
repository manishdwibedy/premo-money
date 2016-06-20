//
//  SettingsViewController.swift
//  Premo
//
//  Created by Manish Dwibedy on 6/20/16.
//  Copyright © 2016 Manish Dwibedy. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var dob: UITextField!
    @IBOutlet weak var address: UITextView!
    @IBOutlet weak var datepicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
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
}
