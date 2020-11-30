//
//  MockGeofication.swift
//  Cracker
//
//  Created by Jovan ho on 2020/11/30.
//

import Foundation
import MapKit
import CoreLocation

class MockGeotification: NSObject {
    
    var coordinate: CLLocationCoordinate2D
    var radius: CLLocationDistance
    var identifier: String
    
    init(coordinate: CLLocationCoordinate2D, radius: CLLocationDistance, identifier: String) {
        self.coordinate = coordinate
        self.radius = radius
        self.identifier = identifier
    }
}
