//
//  HostingPartyViewController.swift
//  Premo
//
//  Created by Manish Dwibedy on 6/20/16.
//  Copyright © 2016 Manish Dwibedy. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

// This ViewController handles the hosting of parties
class HostingPartyViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate {
    // Get the party's creation timestamp
    let partyID = Util.getPartyIdentifier()
    
    // The DB reference
    let db_ref = FIRDatabase.database().reference()
    
    // The UID representing the current logged in user
    let uid = FIRAuth.auth()?.currentUser?.uid
    
    @IBOutlet weak var maxCapacity: UILabel!
    @IBOutlet weak var currentDonationAmount: UILabel!
    @IBOutlet weak var donationSlider: UISlider!
    @IBOutlet weak var partyType: UISegmentedControl!
    @IBOutlet weak var partyTitle: UITextField!
    @IBOutlet weak var partyDescription: UITextView!
    
    /*!
     * @discussion Setting the party's capacity label
     * @param sender - UIStepper
     */
    @IBAction func valueChanged(sender: UIStepper) {
        maxCapacity.text = Int(sender.value).description
    }
    
    /*!
     * @discussion Setting the party's donation amount, after rounding up to the nearest dollor
     * @param sender - UISlider
     */
    @IBAction func donationAmountChanged(sender: UISlider) {
        let roundedValue = round(sender.value / 1) * 1
        sender.value = roundedValue
        
        currentDonationAmount.text = "Donating $\(sender.value)"
    }
    
    /*!
     * @discussion Hosting a new party
     * @param sender - UIButton
     */
    @IBAction func hostParty(sender: UIButton) {
        let userInfoRef = db_ref.child("user_info")
        var party_type = Constant.party_type[self.partyType.selectedSegmentIndex]
        let party_title = partyTitle.text
        let party_description = partyDescription.text
        let index = party_type.startIndex.advancedBy(0)
        party_type = String(party_type[index])
        
        // Getting the user info from the DB
        let _ = userInfoRef.observeEventType(FIRDataEventType.Value, withBlock: { (snapshot) in
            let data = snapshot.value as! [String : AnyObject]
            
            let user_data = data[self.uid!]!
            
            let lat = user_data["lat"]!
            let long = user_data["long"]!
            
            let party_data = [
                "title" : party_title!,
                "desc" : party_description!,
                "host": "\(self.uid!)",
                "timestamp": self.partyID,
                "capacity": Int(self.maxCapacity.text!)!,
                "donations" : self.donationSlider.value,
                "lat": String(lat!),
                "long": String(long!),
                "type" : party_type
            ]
            
            // Adding a new party to the DB
            self.db_ref.child("party").child("\(self.uid!)::\(self.partyID)").setValue(party_data)
            
            // Moving to the party map, after adding the party to the DB.
            self.performSegueWithIdentifier("showPartyOnMap", sender: nil)
        })
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        
        donationSlider.continuous = false
        currentDonationAmount.text = "Donating $\(donationSlider.value)"
        
        partyDescription.delegate = self
        partyTitle.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*!
     * @discussion Hidding the keyboard if return key is pressed
     * @param textField - UITextView
     * @return true, allows to do usal return functionality
     */
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    /*!
     * @discussion Hidding the keyboard if the return key is pressed
     * @param textField - UITextField
     * @return true, allows to do usal return functionality
     */
    func textFieldShouldReturn(textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        return true
    }
}
