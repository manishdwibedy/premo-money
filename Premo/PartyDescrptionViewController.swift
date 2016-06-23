//
//  PartyDescrptionViewController.swift
//  Premo
//
//  Created by Manish Dwibedy on 6/22/16.
//  Copyright © 2016 Manish Dwibedy. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class PartyDescrptionViewController: UIViewController {
    var party: Party?
    let db_ref = FIRDatabase.database().reference()
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var partyDescription: UITextView!
//    @IBOutlet weak var partyDescription: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.topItem?.title = party?.title
        partyDescription.text = party?.info
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
    
    @IBAction func joinParty(sender: UIButton) {
        print("Joining the party")
        
        let host = party?.host
        let timestamp = party?.timestamp
        let party_ID = "\(host!)::\(timestamp!)"
        
        let uid = FIRAuth.auth()?.currentUser!.uid
        party!.addGuest(uid!)

        self.db_ref.child("party/\(party_ID)/guests").setValue(party?.guests)

    }
    
}
