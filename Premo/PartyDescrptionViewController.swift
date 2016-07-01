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
import Braintree

// This ViewController would handle the party description screen
class PartyDescrptionViewController: UIViewController, BTDropInViewControllerDelegate {
    var party: Party?
    
    // The DB reference
    let db_ref = FIRDatabase.database().reference()
    
    // The UID representing the current logged in user
    let uid = FIRAuth.auth()?.currentUser!.uid
    
    // BrainTree client
    var braintreeClient: BTAPIClient?
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var partyDescription: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        navigationBar.topItem?.title = party?.title
        partyDescription.text = party?.info
        
        initBrainTree()
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

        tappedMyPayButton()
        
        // Joining the party
        self.db_ref.child("party/\(party_ID)/guests").setValue(party?.guests)

    }
    
    /*!
     * @discussion Initializing the brain tree client
     */
    func initBrainTree(){
        let clientTokenURL = NSURL(string: "https://radiant-harbor-72272.herokuapp.com/client_token")!
        let clientTokenRequest = NSMutableURLRequest(URL: clientTokenURL)
        clientTokenRequest.setValue("text/plain", forHTTPHeaderField: "Accept")
        
        NSURLSession.sharedSession().dataTaskWithRequest(clientTokenRequest) { (data, response, error) -> Void in
            // TODO: Handle errors
            let clientToken = String(data: data!, encoding: NSUTF8StringEncoding)
            
            self.braintreeClient = BTAPIClient(authorization: clientToken!)
            // As an example, you may wish to present our Drop-in UI at this point.
            // Continue to the next section to learn more...
        }.resume()
    }
    
    /*!
     * @discussion <#description#>
     * @param <#param description#>
     * @return <#return description#>
     */
    func dropInViewController(viewController: BTDropInViewController, didSucceedWithTokenization paymentMethodNonce: BTPaymentMethodNonce) {
        // Send payment method nonce to your server for processing
        postNonceToServer(paymentMethodNonce.nonce)
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func dropInViewControllerDidCancel(viewController: BTDropInViewController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func tappedMyPayButton() {
        
        // If you haven't already, create and retain a `BTAPIClient` instance with a
        // tokenization key OR a client token from your server.
        // Typically, you only need to do this once per session.
        // braintreeClient = BTAPIClient(authorization: CLIENT_AUTHORIZATION)
        
        // Create a BTDropInViewController
        let dropInViewController = BTDropInViewController(APIClient: self.braintreeClient!)
        dropInViewController.delegate = self
        
        // This is where you might want to customize your view controller (see below)
        
        // The way you present your BTDropInViewController instance is up to you.
        // In this example, we wrap it in a new, modally-presented navigation controller:
        dropInViewController.navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: UIBarButtonSystemItem.Cancel,
            target: self, action: #selector(PartyDescrptionViewController.userDidCancelPayment))
        let navigationController = UINavigationController(rootViewController: dropInViewController)
        presentViewController(navigationController, animated: true, completion: nil)
    }
    
    func userDidCancelPayment() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func postNonceToServer(paymentMethodNonce: String) {
        let paymentURL = NSURL(string: "https://radiant-harbor-72272.herokuapp.com/checkout")!
        let request = NSMutableURLRequest(URL: paymentURL)
        request.HTTPBody = "amount=10&payment_method_nonce=\(paymentMethodNonce)".dataUsingEncoding(NSUTF8StringEncoding)
        request.HTTPMethod = "POST"
        
        NSURLSession.sharedSession().dataTaskWithRequest(request) { (data, response, error) -> Void in
            // TODO: Handle success or failure
            if error == nil{
                print(data)
                print(response)
                let data_S = NSString(data: data!, encoding: NSUTF8StringEncoding)
                print(data_S!)
                
                let message = data_S?.stringByReplacingOccurrencesOfString(" ", withString: "+")
                self.showAlert("Success", message: message!.uppercaseString)
            }
            else{
                print("Error")
                self.showAlert("Error", message: "Error occured. Please try again.")
            }
        }.resume()
    }
    
    /*!
     * @discussion Method to show an alert
     * @param title - The title of the alert box
     * @param message - The message of the alert box
     */
    func showAlert(title: String, message: String){
        let alertView = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alertView.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        presentViewController(alertView, animated: true, completion: nil)
    }
}
