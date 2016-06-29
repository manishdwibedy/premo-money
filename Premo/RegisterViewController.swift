//
//  RegisterViewController.swift
//  Premo
//
//  Created by Manish Dwibedy on 6/17/16.
//  Copyright © 2016 Manish Dwibedy. All rights reserved.
//

import UIKit
import FirebaseAuth


// This view controller handles the user registration screen
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
    
    /*!
     * @discussion Called when the user stops editing the text fields
     * @param the concerned text field
     * @return true if editing should stop or false if it should continue.
     */
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        // printing the length of the content of the text field
        print(textField.text!.characters.count)
        switch textField.tag {
            case 0:
                // The full name of the user
                print("Name : " + textField.text!)
                
                // If the field is empty
                if(textField.text!.characters.count <= 0){
                    self.showAlert("Missing Name", message: "Please enter your full name!")
                }
                // If the field has less than 4 character
                else if(textField.text!.characters.count < 4){
                    self.showAlert("Invalid Name", message: "Please enter more characters!")
                }
                // If the field doesn't have two words, representing the full name
                else if textField.text!.rangeOfString(" ") == nil{
                    self.showAlert("Invalid Full Name", message: "Please enter your first and last name!")
                }
                break
            case 1:
                // The email adress text field
                print("Email ID : " + textField.text!)
                
                // If the field is empty
                if(textField.text!.characters.count <= 0){
                    self.showAlert("Missing Username", message: "Please enter your email address!")
                }
                // If the content is not a valid email address
                else if(!Util.isValidEmail(textField.text!)){
                    self.showAlert("Invalid Email address", message: "Please enter a valid email address!")
                }
                break
            case 2:
                // The password text field
                print("Password : " + textField.text!)
                
                // If the field is empty
                if(textField.text!.characters.count <= 0){
                    self.showAlert("Missing Password", message: "Please enter your password!")
                }
                // If the content has less than 8 character
                else if(textField.text!.characters.count <= 8){
                    self.showAlert("Invalid Password", message: "Please enter more characters!")
                }
                // If the password is a weak password
                else if(!Util.checkPasswordStrength(textField.text!)){
                    self.showAlert("Invalid Password", message: "Please enter capitals/numberic/special symbols!")
                }
                break
            default:
                print("Error!")
        }
        
        // printing the content of the text field
        print(textField.text)
        
        // By defualt, the text field should stop editing, as the user wanted
        return true
    }
    
    /*!
     * @discussion Registering the user
     * @param the register button
     */
    @IBAction func register(sender: AnyObject) {
        let fullname = self.fullName.text!
        let username = self.username.text!
        let password = self.password.text!
        
        // Salting the user password, for security concerns
        let saltedPassword = Util.salt(password)
        
        print(saltedPassword)
        
        // Trying to register the user with the provided credentials
        FIRAuth.auth()?.createUserWithEmail(username, password: saltedPassword) { (user, error) in
            // If the registration was successful
            if error == nil{
                print("User registration successful!")
                
                // Logging the user, upon successful registration
                self.login(username, password: saltedPassword)
            }
                
            // Handling the registration errors
            else{
                print("User registration failed")
                let error_message = error?.userInfo["NSLocalizedDescription"]! as! String
                self.showAlert("User Registration failed", message: error_message)
            }
        }
        
    }
    
    /*!
     * @discussion Method to show an alert
     * @param title - The title of the alert box
     * @param message - The message of the alert box
     */
    func showAlert(title: String, message: String){
        let alertView = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alertView.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        presentViewController(alertView, animated: true, completion: nil)
    }
    
    /*!
     * @discussion Logging in the user, upon successful registration. Upon login, move to the home page.
     * @param email - user's email address
     * @param password - user's password
     */
    func login(email:String, password: String) {
        FIRAuth.auth()?.signInWithEmail(email, password: password) { (user, error) in
            if user != nil{
                print(user!.displayName)
                print(user!.email)
                print(user!.emailVerified)
                print("User is logged in")
                self.performSegueWithIdentifier("loginRegisteredUser", sender: nil)
            }
            else{
                print("Login issues \(error))")
            }
        }
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
