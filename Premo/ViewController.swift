//
//  ViewController.swift
//  Premo
//
//  Created by Manish Dwibedy on 6/17/16.
//  Copyright © 2016 Manish Dwibedy. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class ViewController: UIViewController {

    let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
    var userLogged: Bool = false
    
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
        }
        
    }
    
    func getFBUserData(){
        if((FBSDKAccessToken.currentAccessToken()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).startWithCompletionHandler({ (connection, result, error) -> Void in
                if (error == nil){
                    print(result)
                }
            })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
//        let loginButton = FBSDKLoginButton()
//        loginButton.center = view.center
//        view.addSubview(loginButton)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

