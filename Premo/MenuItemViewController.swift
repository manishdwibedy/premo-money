//
//  MenuItemViewController.swift
//  Premo
//
//  Created by Manish Dwibedy on 6/23/16.
//  Copyright © 2016 Manish Dwibedy. All rights reserved.
//

import UIKit

class MenuItemViewController: UIViewController {
    @IBOutlet weak var party_type: UISegmentedControl!
    @IBOutlet weak var menu_desc: UITextView!
    @IBOutlet weak var menu_item: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    @IBAction func addMenu(sender: AnyObject) {
        print(party_type.selectedSegmentIndex)
    }
}
