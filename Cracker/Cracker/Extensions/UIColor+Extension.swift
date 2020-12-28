//
//  UIColor.swift
//  Cracker
//
//  Created by Sydney Wu on 2020/11/27.
//

import UIKit

private enum CrackerColor: String {
    
    case W = "FBF6F0"
    
    case Y = "FFDA77"
    
    case O = "FFA45B"
    
    case B = "AEE6E6"
}

extension UIColor {
    
    static let W = renderColor(.W)
    
    static let Y = renderColor(.Y)
    
    static let O = renderColor(.O)
    
    static let B = renderColor(.B)
    
    private static func renderColor(_ color: CrackerColor) -> UIColor? {
        
        return UIColor.hexStringToUIColor(hex: color.rawValue)
        
    }
    
    static func hexStringToUIColor(hex: String) -> UIColor {
        
        var colorStr: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if colorStr.hasPrefix("#") {
            colorStr.remove(at: colorStr.startIndex)
        }
        
        if (colorStr.count) != 6 {
            return UIColor.gray
        }
        
        var rgbValue: UInt64 = 0
        Scanner(string: colorStr).scanHexInt64(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
