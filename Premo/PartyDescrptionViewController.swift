//
//  PartyDescrptionViewController.swift
//  Premo
//
//  Created by Manish Dwibedy on 6/22/16.
//  Copyright © 2016 Manish Dwibedy. All rights reserved.
//

import UIKit

class PartyDescrptionViewController: UIViewController {
    var party: Party?
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var partyDescription: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.topItem?.title = party?.title
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        partyDescription.setContentOffset(CGPointZero, animated: false)
    }
    
    
}
