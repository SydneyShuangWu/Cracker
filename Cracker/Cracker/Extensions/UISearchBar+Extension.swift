//
//  UISearchBar+Extension.swift
//  Cracker
//
//  Created by Sydney Wu on 2020/12/2.
//

import UIKit

func setupSearchBar(for searchBar: UISearchBar) {
    
    if let textfield = searchBar.value(forKey: "searchField") as? UITextField {
        
        textfield.textColor = UIColor.darkGray
        
        textfield.backgroundColor = UIColor.white
        
        if let leftView = textfield.leftView as? UIImageView {
                leftView.image = leftView.image?.withRenderingMode(.alwaysTemplate)
                leftView.tintColor = UIColor.O
        }
    }
}
