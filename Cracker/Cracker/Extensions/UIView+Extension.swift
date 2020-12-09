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
    
    func setupTextFieldBorder() {
        
        layer.borderWidth = 1.5
        
        layer.borderColor = UIColor.systemGray.cgColor
    }
    
    class func fromNib<T: UIView>() -> T {
            return Bundle(for: T.self).loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
}
