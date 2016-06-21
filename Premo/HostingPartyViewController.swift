//
//  HostingPartyViewController.swift
//  Premo
//
//  Created by Manish Dwibedy on 6/20/16.
//  Copyright © 2016 Manish Dwibedy. All rights reserved.
//

import UIKit

class HostingPartyViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    @IBOutlet weak var maxCapacity: UILabel!
    @IBOutlet weak var donationPicker: UIPickerView!
    
    @IBOutlet weak var currentDonationAmount: UILabel!
    @IBOutlet weak var donationSlider: UISlider!
    @IBOutlet weak var donationAmount: UITextField!
    var pickerData: [String] = [String]()
    
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
        pickerData = ["Item 1", "Item 2", "Item 3", "Item 4", "Item 5", "Item 6"]
        
        self.donationPicker.delegate = self
        self.donationPicker.dataSource = self
        
        
        donationSlider.continuous = false
        currentDonationAmount.text = "Donating $\(donationSlider.value)"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // The number of columns of data
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool
    {
        donationPicker.alpha = 1
        return false
    }
}
