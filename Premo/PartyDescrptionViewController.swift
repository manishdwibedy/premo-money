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

// This ViewController would handle the party description screen
class PartyDescrptionViewController: UIViewController {
    var party: Party?
    
    // The DB reference
    let db_ref = FIRDatabase.database().reference()
    
    // The UID representing the current logged in user
    let uid = FIRAuth.auth()?.currentUser!.uid
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var partyDescription: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        navigationBar.topItem?.title = party?.title
        partyDescription.text = party?.info
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*!
     * @discussion This method would scroll the user description text view to the very top
     */
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        partyDescription.setContentOffset(CGPointZero, animated: false)
    }
    
    /*!
     * @discussion Joining the party
     * @param sender - UIButton
     */
    @IBAction func joinParty(sender: UIButton) {
        print("Joining the party")
        
        let host = party?.host
        let timestamp = party?.timestamp
        let party_ID = "\(host!)::\(timestamp!)"
        
        // Adding the current user to the party's guest list
        party!.addGuest(uid!)

        // Joining the party
        self.db_ref.child("party/\(party_ID)/guests").setValue(party?.guests)

    }
    
}
