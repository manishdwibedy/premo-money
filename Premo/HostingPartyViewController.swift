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
    @IBAction func valueChanged(sender: UIStepper) {
        maxCapacity.text = Int(sender.value).description
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
