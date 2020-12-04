//
//  ViewController + Extension.swift
//  Cracker
//
//  Created by Sydney Wu on 2020/11/30.
//

import Foundation
import UIKit

extension UIViewController {
    
    // Check for alert when testing map!!!!!!!!
    func showAlert(withTitle title: String?, message: String?) {
        
      let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
      let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
      alert.addAction(action)
      present(alert, animated: true, completion: nil)
    }
    
    func setupNavigationBar(with title: String) {
        
        let barAppearance = UINavigationBarAppearance()
        
        barAppearance.backgroundColor = UIColor.O

        barAppearance.shadowColor = .clear
        
        self.title = title
        
        barAppearance.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.W!,
            NSAttributedString.Key.font: UIFont(name: "Gill Sans Bold", size: 20)!
        ]
        
        navigationItem.standardAppearance = barAppearance
    }
    
    func setupBackButton() {
        
        self.navigationItem.hidesBackButton = true
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "Back")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(backButtonTap))
    }
    
    @objc func backButtonTap(sender: UIButton) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    func setupCloseButton() {
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "Close")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(closeButtonTap))
    }
    
    @objc func closeButtonTap(sender: UIButton) {
        
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
}


