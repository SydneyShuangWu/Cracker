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
        
        return combineImageAndTitle(image: UIImage(named: "Stage")!, title: locationName!)
    }
    
    func combineImageAndTitle(image: UIImage, title: String) -> UIImage {
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 20))
        label.numberOfLines = 1
        label.textAlignment = .center
        label.textColor = UIColor.black
        label.text = title
        let titleImage = UIImage.imageFromLabel(label: label)
        
        let contextSize = CGSize(width: 100, height: 100)
        
        UIGraphicsBeginImageContextWithOptions(contextSize, false, UIScreen.main.scale)
        
        let rect1 = CGRect(x: 50 - Int(image.size.width / 2), y: 50 - Int(image.size.height / 2), width: Int(image.size.width), height: Int(image.size.height))
        image.draw(in: rect1)
        
        let rect2 = CGRect(x: 0, y: 53 + Int(image.size.height / 2), width: Int(titleImage.size.width), height: Int(titleImage.size.height))
        titleImage.draw(in: rect2)
        
        let combinedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return combinedImage!
    }
}




