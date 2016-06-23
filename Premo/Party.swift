//
//  Party.swift
//  Premo
//
//  Created by Manish Dwibedy on 6/21/16.
//  Copyright © 2016 Manish Dwibedy. All rights reserved.
//

import MapKit
import UIKit

class Party: NSObject, MKAnnotation {
    var title: String?
    var coordinate: CLLocationCoordinate2D
    var info: String
    var type: String
    var host: String
    var capacity: Int
    var timestamp: String
    var guests = [String]()
    
    init(title: String, coordinate: CLLocationCoordinate2D, info: String, type: String, host: String, capacity: Int, timestamp: String) {
        self.title = title
        self.coordinate = coordinate
        self.info = info
        self.type = type
        self.host = host
        self.capacity = capacity
        self.timestamp = timestamp
    }
    
    func addGuest(guestID: String) -> Int{
        guests.append(guestID)
        return guests.count
    }
}