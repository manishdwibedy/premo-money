//
//  ViewController.swift
//  Premo
//
//  Created by Manish Dwibedy on 6/17/16.
//  Copyright © 2016 Manish Dwibedy. All rights reserved.
//

import UIKit
import FBSDKLoginKit

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
                    if(fbloginresult.grantedPermissions.contains("email"))
                    {
                        self.getFBUserData()
                        self.userLogged = true
                        self.loginButton.setTitle("Logout?", forState: UIControlState.Normal)
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
    

    @IBAction func login(sender: AnyObject) {
    }

}

