//
//  UIImage+Extension.swift
//  Cracker
//
//  Created by Sydney Wu on 2020/12/11.
//

import Foundation
import UIKit

extension UIImage {
    
    // Convert label to image
    class func imageFromLabel(label: UILabel) -> UIImage {
        
        UIGraphicsBeginImageContextWithOptions(label.bounds.size, false, 0.0)
        label.layer.render(in: UIGraphicsGetCurrentContext()!)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img!
    }
}
