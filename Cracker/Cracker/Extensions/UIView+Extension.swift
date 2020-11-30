//
//  UIView.swift
//  Cracker
//
//  Created by Jovan ho on 2020/11/27.
//

import UIKit

extension UIView {
    
    func setupCornerRadius() {
        
        self.layer.cornerRadius = 10
        
        self.layer.masksToBounds = true
    }
    
    func setupBorder() {
        
        self.layer.borderWidth = 3
        
        self.layer.borderColor = UIColor.O?.cgColor
    }
}
