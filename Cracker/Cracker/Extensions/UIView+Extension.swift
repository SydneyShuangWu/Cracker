//
//  UIView.swift
//  Cracker
//
//  Created by Sydney Wu on 2020/11/27.
//

import UIKit

extension UIView {
    
    func setupBorder() {
        
        layer.borderWidth = 3
        
        layer.borderColor = UIColor.O?.cgColor
    }
    
    func setupCornerRadius() {
        
        layer.cornerRadius = 10
        
        layer.masksToBounds = true
    }
    
    
}
