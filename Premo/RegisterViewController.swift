//
//  RegisterViewController.swift
//  Premo
//
//  Created by Manish Dwibedy on 6/17/16.
//  Copyright © 2016 Manish Dwibedy. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var fullName: UITextField!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        fullName.delegate = self
        username.delegate = self
        password.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func register(sender: AnyObject) {
    }
    
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        print(textField.text!.characters.count)
        switch textField.tag {
            case 0:
                print("Name : " + textField.text!)
                if(textField.text!.characters.count <= 0){
                    self.showAlert("Missing Name", message: "Please enter your full name!")
                }
                break
            case 1:
                print("Username : " + textField.text!)
                if(textField.text!.characters.count <= 0){
                    self.showAlert("Missing Username", message: "Please enter your username!")
                }
                break
            case 2:
                print("Password : " + textField.text!)
                if(textField.text!.characters.count <= 0){
                    self.showAlert("Missing Password", message: "Please enter your password!")
                }
                break
            default:
                print("Error!")
        }
        print(textField.text)
        return true
    }
    
    func showAlert(title: String, message: String){
        let alertView = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alertView.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        presentViewController(alertView, animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
