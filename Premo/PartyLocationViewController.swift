//
//  PartyLocationViewController.swift
//  Premo
//
//  Created by Manish Dwibedy on 6/20/16.
//  Copyright © 2016 Manish Dwibedy. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import FirebaseDatabase
import FirebaseAuth

// This ViewController handles the party location screen
class PartyLocationViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, UITableViewDelegate, UITableViewDataSource  {
    @IBOutlet weak var map: MKMapView!
    var locationManager: CLLocationManager!
    
    // The list of parties
    var parties = [MKAnnotation]()
    
    // The list of filtered parties
    var filteredParties = [MKAnnotation]()
    
    // Holds the current party
    var selectedParty: Party?
    
    // Is a party selected
    var isPartySelected = false
    
    // User's Info
    var userInfo = [String: NSDictionary]()
    
    // The DB reference
    let db_ref = FIRDatabase.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        
        // Getting the user's location
        self.locationManager = CLLocationManager()
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        self.locationManager.delegate = self;
        
        let initialLocation = CLLocation(latitude: 34.051454, longitude: -118.249029)
        centerMapOnLocation(initialLocation)
        
        // present an alert indicating location authorization required
        // and offer to take the user to Settings for the app via
        // UIApplication -openUrl: and UIApplicationOpenSettingsURLString
        let status = CLLocationManager.authorizationStatus()
        if status == .NotDetermined || status == .Denied || status == .AuthorizedWhenInUse {
            locationManager.requestAlwaysAuthorization()
            locationManager.requestWhenInUseAuthorization()
        }
        locationManager.startUpdatingLocation()
        locationManager.startUpdatingHeading()
        
        map.showsUserLocation = true
        
        let settingRef = db_ref.child("party")
        
        var count = 1
        
        // Getting the party information
        let _ = settingRef.observeSingleEventOfType(FIRDataEventType.Value, withBlock: { (snapshot) in
            let party_data = snapshot.value as! [String : AnyObject]
            
            for (_, partyData) in party_data{
                let party_dict = partyData as? NSDictionary
                
                let lat = party_dict!["lat"] as! String
                let long = party_dict!["long"] as! String
                let type = party_dict!["type"] as! String
                let capacity = party_dict!["capacity"] as! Int
                let host = party_dict!["host"] as! String
                let timestamp = party_dict!["timestamp"] as! String
                let title = party_dict!["title"] as! String
                let desc = party_dict!["desc"] as! String
                
                let party = Party(title: title,
                    coordinate: CLLocationCoordinate2D(latitude: Double(lat)!, longitude: Double(long)!),
                    info: desc,
                    type: type,
                    host: host,
                    capacity: capacity,
                    timestamp: timestamp
                )
                self.parties.append(party)
            }
            self.filteredParties = self.parties
            self.map.addAnnotations(self.parties)
            self.party_list.reloadData()
            
            // Show the hybrid parties
            self.showParty("H")
            count += 1
            
        })
        
        // Getting the user information
        let userRef = db_ref.child("user_info")
        let _ = userRef.observeSingleEventOfType(FIRDataEventType.Value, withBlock: { (snapshot) in
            let user_data = snapshot.value as! [String : AnyObject]
            print(user_data)
            
            var user_info = [String: NSDictionary]()
            for (userID, user) in user_data{
                let user_dict = user as? NSDictionary
                
                user_info[userID] = user_dict
            }
            self.userInfo = user_info
        })

        map.delegate = self
        party_list.delegate = self
        party_list.dataSource = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    let regionRadius: CLLocationDistance = 5000
    /*!
     * @discussion Centering the map to cover 5000 miles
     * @param location - location of the map
     */
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius * 2.0, regionRadius * 2.0)
        map.setRegion(coordinateRegion, animated: true)
    }
    
    /*!
     * @discussion Location maanager to handle the location
     * @param manager - location manager
     * @param didUpdateLocations - locations
     */
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        
        let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        _ = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
//        self.map.setRegion(region, animated: true)
    }
    
    /*!
     * @discussion Adding an annotation on the map
     * @param lat - latitude
     * @param long - longitude
     * @param name - name of the annotaion
     */
    func addAnnotationsOnMap(lat: Double, long: Double, name: String){
        // show the location on the map
        let location = CLLocationCoordinate2DMake(lat, long)
        
        // Drop a pin
        let dropPin = MKPointAnnotation()
        
        dropPin.coordinate = location
        dropPin.title = name
        
        map.addAnnotation(dropPin)
    }
    
    /*!
     * @discussion Rendering the mapview
     * @param mapView - MKMapView
     * @param viewForAnnotation - MKAnnotation
     * @return nil
     */
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        // ID for the annotation
        let identifier = "Party"
        
        // Checking if the annotation is a party annotation
        if annotation is Party {
            // Getting the annotation using the ID
            var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier)
            
            let party = annotation as! Party
            
            if annotationView == nil {
                // Creating an annotation
                annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView!.canShowCallout = true
                annotationView!.image = UIImage(named:"party")
                
                // Creating the detail button
                let btn = UIButton(type: .DetailDisclosure)
                btn.tintColor = UIColor.purpleColor()
                annotationView!.rightCalloutAccessoryView = btn
                
                // Adding the user icon on the annotation
                let hostIcon = UIImageView(frame: CGRectMake(0, 0, 45, 45))
                hostIcon.image=UIImage(named: "dummy-user.jpg")
                annotationView?.leftCalloutAccessoryView = hostIcon
                
                // Adding the subtitle on the annotation
                let subtitleView = UILabel()
                subtitleView.font = subtitleView.font.fontWithSize(12)
                subtitleView.numberOfLines = 0
                subtitleView.text = party.info
                annotationView!.detailCalloutAccessoryView = subtitleView
            } else {
                // If the annotation is not nil, then use it
                annotationView!.annotation = annotation
            }
            return annotationView
        }
        
        // 7
        return nil
    }
    
    /*!
     * @discussion Showing an alert box when the detail button is clicked
     * @param mapView - MKMapView
     * @param annotationView - MKAnnotationView
     * @param calloutAccessoryControlTapped - UIControl
     */
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let party = view.annotation as! Party
        let placeName = party.title
        let placeInfo = party.info
        
        // Adding an alert box
        let ac = UIAlertController(title: placeName, message: placeInfo, preferredStyle: .Alert)
        
        // Create the OK action
        let okAction = UIAlertAction(title: "OK", style: .Default, handler: { (action: UIAlertAction!) in
            self.isPartySelected = true
            self.selectedParty = party
            self.showPartyDescription()
        })
        
        // Create the cancel action
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: { (action: UIAlertAction!) in
            self.isPartySelected = false
        })
        // Add the actions
        ac.addAction(okAction)
        ac.addAction(cancelAction)

        presentViewController(ac, animated: true, completion: nil)
    }
    
    /*!
     * @discussion Filtering the parties on the based of segmented control
     * @param sender - UISegmentedControl
     */
    @IBAction func typeChanged(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
            case 0:
                showParty("H")
            case 1:
                showParty("S")
            case 2:
                showParty("I")
            default:
                print("Error!")
        }

    }
    
    /*!
     * @discussion Filtering the parties
     * @param type - the party's type
     */
    func showParty(type: String){
        // If showing the parties on the map
        if currentDisplayStyle == "map"{
            self.map.removeAnnotations(self.parties)
            var filteredAnnotations = [MKAnnotation]()
            
            // For hybrid, show all parties
            if type == "H"{
                filteredAnnotations = self.parties
            }
            else{
                for annotation in self.parties{
                    let annotation = annotation as! Party
                    if annotation.type == type{
                        filteredAnnotations.append(annotation)
                    }
                }
            }
            map.addAnnotations(filteredAnnotations)
        }
            
        // If showing the parties on the list
        else{
            self.filteredParties = [MKAnnotation]()
            
            // For hybrid, show all parties
            if type == "H"{
                self.filteredParties = self.parties
            }
            else{
                for annotation in self.parties{
                    let annotation = annotation as! Party
                    if annotation.type == type{
                        self.filteredParties.append(annotation)
                    }
                }
            }
            party_list.reloadData()
        }
        
    }
    
    /*!
     * @discussion Show the party description page
     */
    func showPartyDescription(){
        print("segue!!")
        self.performSegueWithIdentifier("showPartyDescription", sender: nil)
    }
    
    /*!
     * @discussion Set the party's data to the party description screen
     * @param segue: UIStoryboardSegue
     * @param sender: AnyObject!
     */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "showPartyDescription") {
            //get a reference to the destination view controller
            let destinationVC:PartyDescrptionViewController = segue.destinationViewController as! PartyDescrptionViewController
            
            if(self.isPartySelected){
                destinationVC.party = self.selectedParty
            }
        }
    }
    
    
    @IBOutlet weak var changeDisplay: UIBarButtonItem!
    @IBOutlet weak var party_list: UITableView!
    
    // By default, the current display is map
    var currentDisplayStyle = "map"
    
    /*!
     * @discussion Showing the list view for the parties
     * @param sender: UIBarButtonItem
     */
    @IBAction func showListView(sender: UIBarButtonItem) {
        print("show list view")
        
        if currentDisplayStyle == "map"{
            UIView.animateWithDuration(0.5, animations: {
                self.map.alpha = 0
                self.party_list.alpha = 1
            })
            changeDisplay.title = "Map"
            self.currentDisplayStyle = "list"
        }
        else{
            UIView.animateWithDuration(0.5, animations: {
                self.map.alpha = 1
                self.party_list.alpha = 0
            })
            changeDisplay.title = "List"
            self.currentDisplayStyle = "map"
        }
        
    }
    
    // Number of sections in the party list
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    // Number of rows in the party list
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredParties.count
    }
    
    /*!
     * @discussion Rendering t
     * @param <#param description#>
     * @return <#return description#>
     */
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)

        let row = indexPath.row
        let party = self.filteredParties[row] as! Party
        
        cell.textLabel?.text = "\(party.title!)"
        let hostInfo = self.userInfo[party.host]
        cell.detailTextLabel?.text = "\(hostInfo!["address"]!)"
        return cell
    }
    /*!
     * @discussion <#description#>
     * @param <#param description#>
     * @return <#return description#>
     */
    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath?{
        self.selectedParty = self.parties[indexPath.row] as? Party
        isPartySelected = true
        
        self.performSegueWithIdentifier("showPartyDescription", sender: nil)
        return indexPath
    }
    
}
