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

class ViewController: UIViewController, UITextFieldDelegate {

    let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
    var userLogged: Bool = false
    @IBOutlet weak var userLabel: UILabel!
    
    @IBOutlet weak var loginButton: UIButton!
    @IBAction func facebookLogin(sender: AnyObject) {
        if (!userLogged){
            fbLoginManager .logInWithReadPermissions(["email"], handler: { (result, error) -> Void in
                if (error == nil){
                    let fbloginresult : FBSDKLoginManagerLoginResult = result
                    if(fbloginresult.isCancelled){
                        self.showAlert("Facebook Login Error", message: "Could not login using Facebook!")
                    }
                    else{
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
        else{
            self.fbLoginManager.logOut()
            //self.userLabel.text = "Facebook Login"
            self.loginButton.setTitle("Facebook Login", forState: UIControlState.Normal)
            self.userLogged = false
        }
        
    }
    
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
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        username.resignFirstResponder()
        password.resignFirstResponder()
        return true
    }
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        print(textField.text!.characters.count)
        switch textField.tag {
        case 0:
            print("Username : " + textField.text!)
            if(textField.text!.characters.count <= 0){
                self.showAlert("Missing Username", message: "Please enter your username!")
            }
            else if(!Util.isValidEmail(textField.text!)){
                self.showAlert("Invalid Email address", message: "Please enter a valid email address!")
            }
            break
        case 1:
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
    
    func showAlert(title: String, message: String){
        let alertView = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alertView.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        presentViewController(alertView, animated: true, completion: nil)
    }

    @IBAction func login(sender: AnyObject) {
        let username = self.username.text!
        let password = self.password.text!
        
        FIRAuth.auth()?.signInWithEmail(username, password: Util.salt(password)) { (user, error) in
            if user != nil{
                print(user!.displayName)
                print(user!.email)
                print(user!.emailVerified)
                print("User is logged in")
                self.performSegueWithIdentifier("showHomePage", sender: sender)
            }
            else{
                print("Login issues \(error))")
            }
        }
    }
    
    

}

