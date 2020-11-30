//
//  MockCharacter.swift
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
            return #imageLiteral(resourceName: "Icon_Menu")
        }
        
        switch name {
        case "Sponge Bob":
            return #imageLiteral(resourceName: "Image-1")
        case "Krusty Krab":
            return #imageLiteral(resourceName: "Image")
        default:
            return #imageLiteral(resourceName: "Icon_Menu")
        }
    }
    
}
