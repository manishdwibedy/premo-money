//
//  RegisterViewController.swift
//  Premo
//
//  Created by Manish Dwibedy on 6/17/16.
//  Copyright © 2016 Manish Dwibedy. All rights reserved.
//

import UIKit
import FirebaseAuth

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
    
    
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        print(textField.text!.characters.count)
        switch textField.tag {
            case 0:
                print("Name : " + textField.text!)
                if(textField.text!.characters.count <= 0){
                    self.showAlert("Missing Name", message: "Please enter your full name!")
                }
                else if(textField.text!.characters.count <= 3){
                    self.showAlert("Invalid Name", message: "Please enter more characters!")
                }
                else if textField.text!.rangeOfString(" ") == nil{
                    self.showAlert("Invalid Full Name", message: "Please enter your first and last name!")
                }
                break
            case 1:
                print("Email ID : " + textField.text!)
                if(textField.text!.characters.count <= 0){
                    self.showAlert("Missing Username", message: "Please enter your email address!")
                }
                else if(!Util.isValidEmail(textField.text!)){
                    self.showAlert("Invalid Email address", message: "Please enter a valid email address!")
                }
                break
            case 2:
                print("Password : " + textField.text!)
                if(textField.text!.characters.count <= 0){
                    self.showAlert("Missing Password", message: "Please enter your password!")
                }
                else if(textField.text!.characters.count <= 8){
                    self.showAlert("Invalid Password", message: "Please enter more characters!")
                }
                else if(!Util.checkPasswordStrength(textField.text!)){
                    self.showAlert("Invalid Password", message: "Please enter capitals/numberic/special symbols!")
                }
                break
            default:
                print("Error!")
        }
        print(textField.text)
        return true
    }
    
    @IBAction func register(sender: AnyObject) {
        let fullname = self.fullName.text!
        let username = self.username.text!
        let password = self.password.text!
        
        let saltedPassword = Util.salt(password)
        
        print(saltedPassword)
        
        FIRAuth.auth()?.createUserWithEmail(username, password: saltedPassword) { (user, error) in
            if error == nil{
                print("User registration successful!")
            }
            else{
                print("User registration failed")
                let error_message = error?.userInfo["NSLocalizedDescription"]! as! String
                self.showAlert("User Registration failed", message: error_message)
            }
        }
        
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
