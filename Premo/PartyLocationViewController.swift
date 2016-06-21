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

class PartyLocationViewController: UIViewController, CLLocationManagerDelegate  {
    @IBOutlet weak var map: MKMapView!
    var locationManager: CLLocationManager!

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
        map.mapType = MKMapType(rawValue: 0)!
        map.userTrackingMode = MKUserTrackingMode(rawValue: 2)!
        
        self.addAnnotationsOnMap(34.049297, long: -118.253770, name: "Millennium Biltmore Hotel")
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
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        self.map.setRegion(region, animated: true)
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
}
