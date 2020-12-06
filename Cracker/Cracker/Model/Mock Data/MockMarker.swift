//
//  MockMarker.swift
//  Cracker
//
//  Created by Sydney Wu on 2020/11/28.
//

import Foundation
import MapKit

class MockMarker: NSObject, MKAnnotation {
    let name: String?
    let brief: String?
    let category: String?
    let coordinate: CLLocationCoordinate2D
    
    init(
        name: String?,
        brief: String?,
        category: String?,
        coordinate: CLLocationCoordinate2D
    ) {
        self.name = name
        self.brief = brief
        self.category = category
        self.coordinate = coordinate
        
        super.init()
    }
    
    // Title of the annotation
    var title: String? {
        return name
    }
    
    // Subtitle of the annotation
    var subtitle: String? {
        return brief
    }
    
    var markerTintColor: UIColor {
        
        switch category {
        
        case "Character":
            return .systemYellow
        case "Location":
            return .systemBlue
        default:
            return .systemGray
        }
    }
    
    var image: UIImage {
        
        guard let name = name else {
            return #imageLiteral(resourceName: "Character")
        }
        
        switch name {
        case "Sponge Bob":
            return #imageLiteral(resourceName: "Character")
        case "Krusty Krab":
            return #imageLiteral(resourceName: "Stage")
        default:
            return #imageLiteral(resourceName: "Character")
        }
    }
    
}

// MARK: - Mock Data
let mockMarkers: [MockMarker] = [
    
    MockMarker(
        name: "Sponge Bob",
        brief: "A citizen in Bikini Bottom",
        category: "Character",
        coordinate: CLLocationCoordinate2D(
            latitude: 25.037876, longitude: 121.568167)
    ),
    MockMarker(
        name: "Krusty Krab",
        brief: "Famous for its signature burger, the Krabby Patty, the formula to which is a closely guarded trade secret",
        category: "Location",
        coordinate: CLLocationCoordinate2D(
            latitude: 25.038284, longitude: 121.560330)
    )
]
