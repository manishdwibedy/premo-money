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
    
    init(title: String, coordinate: CLLocationCoordinate2D, info: String) {
        self.title = title
        self.coordinate = coordinate
        self.info = info
    }
}