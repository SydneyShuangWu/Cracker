//
//  CLLocation+Extension.swift
//  Cracker
//
//  Created by Sydney Wu on 2020/12/10.
//

import Foundation
import CoreLocation

extension CLLocationCoordinate2D {

    func distance(from: CLLocationCoordinate2D) -> CLLocationDistance {
        
        let destination = CLLocation(latitude: from.latitude, longitude: from.longitude)
        
        return CLLocation(latitude: latitude, longitude: longitude).distance(from: destination)
    }
    
    func switchCoordinateType() -> CLLocation {
        
        let getLat: CLLocationDegrees = self.latitude
        let getLng: CLLocationDegrees = self.longitude
        
        return CLLocation(latitude: getLat, longitude: getLng)
    }
}
