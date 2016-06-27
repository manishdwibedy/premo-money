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

class PartyLocationViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, UITableViewDelegate, UITableViewDataSource  {
    @IBOutlet weak var map: MKMapView!
    var locationManager: CLLocationManager!
    var annotations = [MKAnnotation]()
    var selectedParty: Party?
    var isPartySelected = false
    var userInfo = [String: NSDictionary]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        
        self.locationManager = CLLocationManager()
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        self.locationManager.delegate = self;
        
        let initialLocation = CLLocation(latitude: 34.051454, longitude: -118.249029)
        centerMapOnLocation(initialLocation)
        
        let status = CLLocationManager.authorizationStatus()
        if status == .NotDetermined || status == .Denied || status == .AuthorizedWhenInUse {
            // present an alert indicating location authorization required
            // and offer to take the user to Settings for the app via
            // UIApplication -openUrl: and UIApplicationOpenSettingsURLString
            locationManager.requestAlwaysAuthorization()
            locationManager.requestWhenInUseAuthorization()
        }
        locationManager.startUpdatingLocation()
        locationManager.startUpdatingHeading()
        
        map.showsUserLocation = true
        
        let db_ref = FIRDatabase.database().reference()
        
        let settingRef = db_ref.child("party")
        
        var count = 1
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
                
                let party = Party(title: "Party \(count)",
                    coordinate: CLLocationCoordinate2D(latitude: Double(lat)!, longitude: Double(long)!),
                    info: "Description for party \(count) would come here",
                    type: type,
                    host: host,
                    capacity: capacity,
                    timestamp: timestamp
                )
                self.annotations.append(party)
            }
            self.map.addAnnotations(self.annotations)
            self.party_list.reloadData()
            
            self.showParty("H")
            count += 1
            
        })
        
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
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius * 2.0, regionRadius * 2.0)
        map.setRegion(coordinateRegion, animated: true)
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        
        let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        _ = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
//        self.map.setRegion(region, animated: true)
    }
    
    func addAnnotationsOnMap(lat: Double, long: Double, name: String){
        // show the location on the map
        let location = CLLocationCoordinate2DMake(lat, long)
        
        // Drop a pin
        let dropPin = MKPointAnnotation()
        
        dropPin.coordinate = location
        dropPin.title = name
        
        map.addAnnotation(dropPin)
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        // 1
        let identifier = "Party"
        
        // 2
        if annotation is Party {
            // 3
            var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier)
            
            if annotationView == nil {
                //4
                annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView!.canShowCallout = true
                annotationView!.image = UIImage(named:"party")
                
                // 5
                let btn = UIButton(type: .DetailDisclosure)
                annotationView!.rightCalloutAccessoryView = btn
            } else {
                // 6
                annotationView!.annotation = annotation
            }
            return annotationView
        }
        
        // 7
        return nil
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let party = view.annotation as! Party
        let placeName = party.title
        let placeInfo = party.info
        
        
        let ac = UIAlertController(title: placeName, message: placeInfo, preferredStyle: .Alert)
        
        // Create the actions
        let okAction = UIAlertAction(title: "OK", style: .Default, handler: { (action: UIAlertAction!) in
            self.isPartySelected = true
            self.selectedParty = party
            self.showPartyDescription()
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: { (action: UIAlertAction!) in
            self.isPartySelected = false
        })
        // Add the actions
        ac.addAction(okAction)
        ac.addAction(cancelAction)

        presentViewController(ac, animated: true, completion: nil)
    }
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
    
    func showParty(type: String){
        self.map.removeAnnotations(self.annotations)
        var filteredAnnotations = [MKAnnotation]()
        
        for annotation in self.annotations{
            let annotation = annotation as! Party
            if annotation.type == type{
                filteredAnnotations.append(annotation)
            }
            
        }
        map.addAnnotations(filteredAnnotations)

    }
    
    func showPartyDescription(){
        print("segue!!")
        self.performSegueWithIdentifier("showPartyDescription", sender: nil)
    }
    
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
    var currentDisplayStyle = "map"
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
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return annotations.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)

        let row = indexPath.row
        let party = self.annotations[row] as! Party
        
//        //let ID = party["host"] + "-" + party["lat"] + " " + party["long"]
        cell.textLabel?.text = "\(party.title!)"
        let hostInfo = self.userInfo[party.host]
        cell.detailTextLabel?.text = "\(hostInfo!["address"]!)"
        return cell
    }
    
    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath?{
        self.selectedParty = self.annotations[indexPath.row] as? Party
        isPartySelected = true
        
        self.performSegueWithIdentifier("showPartyDescription", sender: nil)
        return indexPath
    }
    
}
