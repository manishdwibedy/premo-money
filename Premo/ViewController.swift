//
//  ViewController.swift
//  Premo
//
//  Created by Manish Dwibedy on 6/17/16.
//  Copyright © 2016 Manish Dwibedy. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FirebaseAuth


// This View Controller handles the the login screen that shows up
// as the first screen, where the user can login either using his email address
// or using his facebook account, the user can register for an account as well.
class ViewController: UIViewController, UITextFieldDelegate {

    let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
    
    // Denotes whether the user is logged in or no
    var userLogged: Bool = false
    
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    
    /*!
     * @discussion This method would login in the user using the user's facebook credentials
     * @param the sender object, the 'facebook login' button
     */
    @IBAction func facebookLogin(sender: AnyObject) {
        
        // If the user is not logged in, then try to login the user
        if (!userLogged){
            
            // Logging with facebook
            fbLoginManager.logInWithReadPermissions(["email"], handler: { (result, error) -> Void in
                
                // If there was not error, while trying to login
                if (error == nil){
                    let fbloginresult : FBSDKLoginManagerLoginResult = result
                    
                    // If the user cancelled the login using facebook
                    if(fbloginresult.isCancelled){
                        self.showAlert("Facebook Login Error", message: "Could not login using Facebook!")
                    }
                        
                    // If everything went through fine
                    else{
                        // If we could get the user's email address
                        if(fbloginresult.grantedPermissions.contains("email"))
                        {
                            self.getFBUserData()
                            self.userLogged = true
                            self.loginButton.setTitle("Logout?", forState: UIControlState.Normal)
                        }
                    }
                    
                    
                }
            })
        }
            
        // If the user is already logged in, then try to logout the user
        else{
            self.fbLoginManager.logOut()
            self.loginButton.setTitle("Facebook Login", forState: UIControlState.Normal)
            self.userLogged = false
        }
        
    }
    
    /*!
     * @discussion Getting the user's facebook data
     */
    func getFBUserData(){
        if((FBSDKAccessToken.currentAccessToken()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).startWithCompletionHandler({ (connection, result, error) -> Void in
                if (error == nil){
                    let username = result["name"]!
                    //self.userLabel.text = String(username!)
                    print(username)
                }
            })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        self.username.delegate = self
        self.password.delegate = self
        
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*!
     * @discussion Used to hide the keyboard when the return key is pressed
     * @param the concerned textfield
     * @return true if the text field should implement its default behavior for the return button; otherwise, false.
     */
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        username.resignFirstResponder()
        password.resignFirstResponder()
        return true
    }
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    
    
    /*!
     * @discussion Called when the user stops editign the text fields
     * @param the concerned text field
     * @return true if editing should stop or false if it should continue.
     */
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        // printing the length of the content of the text field
        print(textField.text!.characters.count)
        
        switch textField.tag {
            // The user name text field
            case 0:
                print("Username : " + textField.text!)
                // if the username field is empty
                if(textField.text!.characters.count <= 0){
                    self.showAlert("Missing Username", message: "Please enter your username!")
                }
                // If the username is not a valid email address
                else if(!Util.isValidEmail(textField.text!)){
                    self.showAlert("Invalid Email address", message: "Please enter a valid email address!")
                }
                break
            // The password field
            case 1:
                print("Password : " + textField.text!)
                // If the password field is empty
                if(textField.text!.characters.count <= 0){
                    self.showAlert("Missing Password", message: "Please enter your password!")
                }
                // If the password length is less than 8
                else if(textField.text!.characters.count <= 8){
                    self.showAlert("Invalid Password", message: "Please enter more characters!")
                }
                // If the password is a 'weak' password
                else if(!Util.checkPasswordStrength(textField.text!)){
                    self.showAlert("Invalid Password", message: "Please enter capitals/numberic/special symbols!")
                }
                break
            // If we get any other tag, ignore it
            default:
                print("Error!")
        }
        // printing the content of the text field
        print(textField.text)
        
        // By defualt, the text field should stop editing, as the user wanted
        return true
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
     * @discussion The login mechanism using email address and password
     * @param <#param description#>
     * @return <#return description#>
     */
    @IBAction func login(sender: AnyObject) {
        var username = self.username.text!
        var password = self.password.text!
        
        // Dummy User 1
        if username.characters.count == 0 || password.characters.count == 0{
            username = "manish.dwibedy@gmail.com"
            password = "Qwerty@123"
        }
        // Dummy User 2
//        if username.characters.count == 0 || password.characters.count == 0{
//            username = "test@test.com"
//            password = "Asdf@1234"
//        }
        
        // Try to authenticate the credentials
        FIRAuth.auth()?.signInWithEmail(username, password: Util.salt(password)) { (user, error) in
            // If the authentication was successful
            if user != nil{
                print(user!.displayName)
                print(user!.email)
                print(user!.emailVerified)
                print("User is logged in")
                
                // Move to the home page screen
                self.performSegueWithIdentifier("showHomePage", sender: sender)
            }
            // Handling authentication issues
            else{
                print("Login issues \(error))")
            }
        }
    }
}

