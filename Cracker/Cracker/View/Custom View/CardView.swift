//
//  CardView.swift
//  Cracker
//
//  Created by Sydney Wu on 2020/12/4.
//

import Foundation
import UIKit

@IBDesignable

class CardView: UIView {

    @IBInspectable var cornerRadius: CGFloat = 10
    @IBInspectable var shadowOffsetWidth: Int = 0
    @IBInspectable var shadowOffsetHeight: Int = 3
    @IBInspectable var shadowColor: UIColor? = UIColor.darkGray
    @IBInspectable var shadowOpacity: Float = 0.5

    override func layoutSubviews() {
        
        layer.cornerRadius = cornerRadius
        
        let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)

        layer.masksToBounds = false
        
        layer.shadowColor = shadowColor?.cgColor
        
        layer.shadowOffset = CGSize(width: shadowOffsetWidth, height: shadowOffsetHeight)
        
        layer.shadowOpacity = shadowOpacity
        
        layer.shadowPath = shadowPath.cgPath
    }

}
