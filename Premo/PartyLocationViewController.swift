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

class PartyLocationViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate  {
    @IBOutlet weak var map: MKMapView!
    var locationManager: CLLocationManager!
    var annotations = [MKAnnotation]()
    
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
        
        for i in [1,2,3,4,5]{
            let party_hybrid = Party(title: "Party \(i) (H)",
                              coordinate: CLLocationCoordinate2D(latitude: 34.049297 + 0.02 * Double(i), longitude: -118.253770 + 0.002 * Double(i)),
                              info: "Description for party \(i) would come here",
                              type:"H")
            let party_sativa = Party(title: "Party \(i) (S)",
                              coordinate: CLLocationCoordinate2D(latitude: 34.049297 + 0.01 * Double(i), longitude: -118.253770 + 0.004 * Double(i)),
                              info: "Description for party \(i) would come here",
                              type:"S")
            let party_indigo = Party(title: "Party \(i) (I)",
                              coordinate: CLLocationCoordinate2D(latitude: 34.049297 + 0.03 * Double(i), longitude: -118.253770 + 0.008 * Double(i)),
                              info: "Description for party \(i) would come here",
                              type:"I")
            annotations.append(party_hybrid)
            annotations.append(party_sativa)
            annotations.append(party_indigo)
        }
        
        map.addAnnotations(annotations)
        
        map.delegate = self
        
        showParty("H")

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
        let capital = view.annotation as! Party
        let placeName = capital.title
        let placeInfo = capital.info
        
        let ac = UIAlertController(title: placeName, message: placeInfo, preferredStyle: .Alert)
        ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
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
}
