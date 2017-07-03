//
//  Place.swift
//  NoteworthAssignment
//
//  Created by Matthew Baron on 7/1/17.
//  Copyright © 2017 Matt Baron. All rights reserved.
//

import Foundation
import CoreLocation


public class Place {
    var location: CLLocationCoordinate2D
    var name: String
    
    init(location: CLLocationCoordinate2D, name: String) {
        self.location = location
        self.name = name
    }
}

