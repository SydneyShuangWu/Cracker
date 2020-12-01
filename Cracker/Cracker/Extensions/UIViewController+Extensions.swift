//
//  ViewController + Extension.swift
//  Cracker
//
//  Created by Sydney Wu on 2020/11/30.
//

import Foundation
import UIKit

extension UIViewController {
    
    func showAlert(withTitle title: String?, message: String?) {
      let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
      let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
      alert.addAction(action)
      present(alert, animated: true, completion: nil)
    }
}
