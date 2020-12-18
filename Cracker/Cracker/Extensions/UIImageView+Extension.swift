//
//  UIImageView+Extension.swift
//  Cracker
//
//  Created by Sydney Wu on 2020/12/18.
//

import Foundation
import UIKit
import Kingfisher

extension UIImageView {

    func loadImage(_ urlString: String?, placeHolder: UIImage? = nil) {

        guard urlString != nil else { return }
        
        let url = URL(string: urlString!)

        self.kf.setImage(with: url, placeholder: placeHolder)
    }
}
