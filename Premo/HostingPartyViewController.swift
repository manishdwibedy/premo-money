//
//  HostingPartyViewController.swift
//  Premo
//
//  Created by Manish Dwibedy on 6/20/16.
//  Copyright © 2016 Manish Dwibedy. All rights reserved.
//

import UIKit

class HostingPartyViewController: UIViewController {
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
