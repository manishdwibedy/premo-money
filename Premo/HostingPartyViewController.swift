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

class HostingPartyViewController: UIViewController {
    let partyID = Util.getPartyIdentifier()
    let db_ref = FIRDatabase.database().reference()
    
    @IBOutlet weak var maxCapacity: UILabel!
    
    @IBOutlet weak var currentDonationAmount: UILabel!
    @IBOutlet weak var donationSlider: UISlider!
    @IBOutlet weak var partyType: UISegmentedControl!
    
    @IBAction func valueChanged(sender: UIStepper) {
        maxCapacity.text = Int(sender.value).description
    }
    @IBAction func donationAmountChanged(sender: UISlider) {
        let roundedValue = round(sender.value / 1) * 1
        sender.value = roundedValue
        
        currentDonationAmount.text = "Donating $\(sender.value)"
    }
    
    @IBAction func hostParty(sender: UIButton) {
        let uid = FIRAuth.auth()?.currentUser?.uid
        let userInfoRef = db_ref.child("user_info")
        var party_type = Constant.party_type[self.partyType.selectedSegmentIndex]
        
        let index = party_type.startIndex.advancedBy(0)
        party_type = String(party_type[index])
        
        let _ = userInfoRef.observeEventType(FIRDataEventType.Value, withBlock: { (snapshot) in
            let data = snapshot.value as! [String : AnyObject]
            
            let user_data = data[uid!]!
            
            let lat = user_data["lat"]!
            let long = user_data["long"]!
            
            let party_data = [
                "capacity": Int(self.maxCapacity.text!)!,
                "donations" : self.donationSlider.value,
                "lat": String(lat!),
                "long": String(long!),
                "type" : party_type
            ]
            self.db_ref.child("party").child(self.partyID).setValue(party_data)
            
            self.performSegueWithIdentifier("showPartyOnMap", sender: nil)

            
        })
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        
        donationSlider.continuous = false
        currentDonationAmount.text = "Donating $\(donationSlider.value)"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
