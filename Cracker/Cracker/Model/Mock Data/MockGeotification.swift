//
//  MockGeofication.swift
//  Cracker
//
//  Created by Sydney Wu on 2020/11/30.
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

// MARK: - Mock Data
let geotification = MockGeotification(
    coordinate: CLLocationCoordinate2D(latitude: 25.037876, longitude: 121.568167),
    radius: 150,
    identifier: "Hi my friend!")
