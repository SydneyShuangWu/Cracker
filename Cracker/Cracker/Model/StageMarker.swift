//
//  MockMarker.swift
//  Cracker
//
//  Created by Sydney Wu on 2020/11/28.
//

import Foundation
import MapKit

class StageMarker: NSObject, MKAnnotation {
    
    let locationName: String?
    let coordinate: CLLocationCoordinate2D
    
    init(
        locationName: String?,
        coordinate: CLLocationCoordinate2D
    ) {
        self.locationName = locationName
        self.coordinate = coordinate
        
        super.init()
    }
    
    // Title of the annotation
    var title: String? {
        
        return locationName
    }
    
    var image: UIImage {
        
        return #imageLiteral(resourceName: "Stage")
    }
    
}
