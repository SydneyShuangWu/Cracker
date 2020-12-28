//
//  RPGMarker.swift
//  Cracker
//
//  Created by Sydney Wu on 2020/12/11.
/*
 RPG markers should include:
 1) Title: character name
 2) Subtitle: location name
 3) Right button callout: character info
 */

import Foundation
import MapKit

class RPGMarker: NSObject, MKAnnotation {
    
    let characterName: String?
    let characterImage: UIImage?
    let characterInfo: String?
    let locationName: String?
    let coordinate: CLLocationCoordinate2D
    
    init(
        characterName: String?,
        characterImage: UIImage?,
        characterInfo: String?,
        locationName: String?,
        coordinate: CLLocationCoordinate2D
    ) {
        self.characterName = characterName
        self.characterImage = characterImage
        self.characterInfo = characterInfo
        self.locationName = locationName
        self.coordinate = coordinate
        
        super.init()
    }
    
    // Title of the annotation
    var title: String? {
        return characterName
    }
    
    // Subtitle of the annotation
    var subtitle: String? {
        return locationName
    }
    
    var image: UIImage? {
        
        return characterImage
    }
}

