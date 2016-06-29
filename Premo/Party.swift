//
//  Party.swift
//  Premo
//
//  Created by Manish Dwibedy on 6/21/16.
//  Copyright © 2016 Manish Dwibedy. All rights reserved.
//

import MapKit
import UIKit

// The party model class
class Party: NSObject, MKAnnotation {
    
    // Party's title
    var title: String?
    
    // Party's Co-ordinates
    var coordinate: CLLocationCoordinate2D
    
    // Party's Description
    var info: String
    
    // Party;s type
    var type: String
    
    // Party's Host
    var host: String
    
    // Party's Capacity
    var capacity: Int
    
    // Party's creation timestamp
    var timestamp: String
    
    // Party's guest list
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
    
    /*!
     * @discussion Adding guest to the party's guest list
     * @param Guest ID to be added
     * @return the length of the guest list
     */
    func addGuest(guestID: String) -> Int{
        guests.append(guestID)
        return guests.count
    }
}