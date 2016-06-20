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
    static func checkPasswordStrength(password: String) -> Bool{
        let capitalTest = NSPredicate(format:"SELF MATCHES %@", ".*[A-Z]+.*")
        let numberTest = NSPredicate(format:"SELF MATCHES %@", ".*[0-9]+.*")
        let specialTest = NSPredicate(format:"SELF MATCHES %@", ".*[!&^%$#@()/]+.*")
        
        
        let capitalresult = capitalTest.evaluateWithObject(password)
        let numberresult = numberTest.evaluateWithObject(password)
        let specialresult = specialTest.evaluateWithObject(password)
        
        return capitalresult && numberresult && specialresult
    }

    static func hash(data: String) -> String {
        let bytes = data.utf8.map({$0})
        let hash = bytes.sha512()
        
        return hash.toHexString()
    }
    
    static func salt(data: String) -> String{
        let hashed = Util.hash(data)
        let salt = "YQeF7wSdbk1Vbfp79umh"
        let saltedPassword = Util.hash(hashed + salt)
        
        return saltedPassword
    }
    
    static func getDeviceID() -> String{
        return UIDevice.currentDevice().identifierForVendor!.UUIDString
    }
    
    // Checking where the input string is a valid email or not
    static func isValidEmail(inputString:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let range = inputString.rangeOfString(emailRegEx, options:.RegularExpressionSearch)
        let result = range != nil ? true : false
        return result
    }
}