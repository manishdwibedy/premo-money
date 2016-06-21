//
//  HostingPartyViewController.swift
//  Premo
//
//  Created by Manish Dwibedy on 6/20/16.
//  Copyright © 2016 Manish Dwibedy. All rights reserved.
//

import UIKit
import FirebaseDatabase

class HostingPartyViewController: UIViewController {
    let partyID = Util.getPartyIdentifier()
    let db_ref = FIRDatabase.database().reference()
    
    @IBOutlet weak var maxCapacity: UILabel!
    
    @IBOutlet weak var currentDonationAmount: UILabel!
    @IBOutlet weak var donationSlider: UISlider!
    
    @IBAction func valueChanged(sender: UIStepper) {
        maxCapacity.text = Int(sender.value).description
    }
    @IBAction func donationAmountChanged(sender: UISlider) {
        let roundedValue = round(sender.value / 1) * 1
        sender.value = roundedValue
        
        currentDonationAmount.text = "Donating $\(sender.value)"
    }
    
    @IBAction func hostParty(sender: UIButton) {
        print(maxCapacity.text!)
        print(donationSlider.value)
        
        let party_data = [
            "capacity": Int(maxCapacity.text!)!,
            "donations" : donationSlider.value,
        ]
        db_ref.child("party").child(partyID).setValue(party_data)
        
        
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
