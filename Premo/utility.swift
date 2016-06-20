//
//  utility.swift
//  Premo
//
//  Created by Manish Dwibedy on 6/17/16.
//  Copyright © 2016 Manish Dwibedy. All rights reserved.
//

import Foundation
import UIKit
import CryptoSwift

class Util{
    
    /*!
     * @discussion Checking the password for its strength. If the password contains a capital alphabet, a number and a special character, then the method returns true, else it would return false
     * @param password string
     * @return Return true if the password is strong.
     */
    static func checkPasswordStrength(password: String) -> Bool{
        let capitalTest = NSPredicate(format:"SELF MATCHES %@", ".*[A-Z]+.*")
        let numberTest = NSPredicate(format:"SELF MATCHES %@", ".*[0-9]+.*")
        let specialTest = NSPredicate(format:"SELF MATCHES %@", ".*[!&^%$#@()/]+.*")
        
        
        let capitalresult = capitalTest.evaluateWithObject(password)
        let numberresult = numberTest.evaluateWithObject(password)
        let specialresult = specialTest.evaluateWithObject(password)
        
        return capitalresult && numberresult && specialresult
    }

    /*!
     * @discussion This method would hash the string using SHA 512
     * @param string data
     * @return hashed string representation of the data
     */
    static func hash(data: String) -> String {
        let bytes = data.utf8.map({$0})
        let hash = bytes.sha512()
        
        return hash.toHexString()
    }
    
    /*!
     * @discussion This method would hash the salted version of the string
     * @param strign data
     * @return salted version of the data
     */
    static func salt(data: String) -> String{
        let hashed = Util.hash(data)
        let salt = "YQeF7wSdbk1Vbfp79umh"
        let saltedPassword = Util.hash(hashed + salt)
        
        return saltedPassword
    }
    
    /*!
     * @discussion Gets the vender identifier to be used as a ID
     * @param <#param description#>
     * @return <#return description#>
     */
    static func getDeviceID() -> String{
        return UIDevice.currentDevice().identifierForVendor!.UUIDString
    }
    
    /*!
     * @discussion Checks where the string is a valid email or not.
     * @param strign data
     * @return returns true if the string is a valid email, else returns false.
     */
    static func isValidEmail(inputString:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let range = inputString.rangeOfString(emailRegEx, options:.RegularExpressionSearch)
        let result = range != nil ? true : false
        return result
    }
}