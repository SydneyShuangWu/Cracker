//
//  StageMarkerView.swift
//  Cracker
//
//  Created by Sydney Wu on 2020/12/11.
//

import Foundation
import MapKit

class StageMarkerView: MKAnnotationView {
    
    override var annotation: MKAnnotation? {
        
        willSet {
            
            guard let stageMarker = newValue as? StageMarker else { return }
            
            canShowCallout = false
            
            image = stageMarker.image
        }
    }
}

class RPGMarkerView: MKAnnotationView {
    
    override var annotation: MKAnnotation? {
        
        willSet {
            
            guard let rpgMarker = newValue as? RPGMarker else { return }
            
            canShowCallout = true
            calloutOffset = CGPoint(x: -5, y: 5)
            rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            
//            image = rpgMarker.image
            
            // Multi-line subtitle
            let detailLabel = UILabel()
            detailLabel.numberOfLines = 0
            detailLabel.font = detailLabel.font.withSize(12)
            detailLabel.text = rpgMarker.subtitle
            detailCalloutAccessoryView = detailLabel
        }
    }
}
