//
//  CharacterAnnotationView.swift
//  Cracker
//
//  Created by Sydney Wu on 2020/11/28.
//

import Foundation
import MapKit

class MarkerAnnotationView: MKMarkerAnnotationView {
    
    override var annotation: MKAnnotation? {
        
        willSet {
            guard let marker = newValue as? MockMarker else { return }
            
            canShowCallout = true
            calloutOffset = CGPoint(x: -5, y: 5)
            rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            
            markerTintColor = marker.markerTintColor
            
            glyphImage = marker.image
        }
    }
}

class MarkerView: MKAnnotationView {
    
    override var annotation: MKAnnotation? {
        
        willSet {
            guard let marker = newValue as? MockMarker else { return }
            
            canShowCallout = true
            calloutOffset = CGPoint(x: -5, y: 5)
            rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            
            image = marker.image
            
            // Multi-line subtitle
            let detailLabel = UILabel()
            detailLabel.numberOfLines = 0
            detailLabel.font = detailLabel.font.withSize(12)
            detailLabel.text = marker.subtitle
            detailCalloutAccessoryView = detailLabel
        }
    }
}


