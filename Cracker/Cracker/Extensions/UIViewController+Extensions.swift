//
//  ViewController + Extension.swift
//  Cracker
//
//  Created by Sydney Wu on 2020/11/30.
//

import Foundation
import UIKit
import Hero

let myStoryboard = UIStoryboard(name: "Main", bundle: nil)

extension UIViewController {
    
    func showAlert(withTitle title: String?, withActionTitle actionTitle: String?, message: String?) {
        
      let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
      let action = UIAlertAction(title: actionTitle, style: .cancel, handler: nil)
        
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
        
        let backBtn = UIButton(type: .custom)
        
        backBtn.setImage(UIImage(named: "Back"), for: .normal)
        
        backBtn.addTarget(self, action: #selector(backButtonTap), for: .touchUpInside)
        
        let leftBarButtonItem = UIBarButtonItem(customView: backBtn)
        
        NSLayoutConstraint.activate([leftBarButtonItem.customView!.widthAnchor.constraint(equalToConstant: 35), leftBarButtonItem.customView!.heightAnchor.constraint(equalToConstant: 35)])
        
        navigationItem.leftBarButtonItem = leftBarButtonItem
    }
    
    @objc func backButtonTap(sender: UIButton) {
        
        _ = navigationController?.popViewController(animated: true)
    }
    
    func setupCloseButton() {
        
        let closeBtn = UIButton(type: .custom)
        
        closeBtn.setImage(UIImage(named: "Close"), for: .normal)
        
        closeBtn.addTarget(self, action: #selector(closeButtonTap), for: .touchUpInside)
        
        let rightBarButtonItem = UIBarButtonItem(customView: closeBtn)
        
        NSLayoutConstraint.activate([rightBarButtonItem.customView!.widthAnchor.constraint(equalToConstant: 35), rightBarButtonItem.customView!.heightAnchor.constraint(equalToConstant: 35)])
        
        navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    @objc func closeButtonTap(sender: UIButton) {
        
        let vc = myStoryboard.instantiateViewController(withIdentifier: "LobbyVc")
        
        let nav = UINavigationController(rootViewController: vc)
        
        nav.modalPresentationStyle = .fullScreen
        
        nav.hero.isEnabled = true
        
        dismiss(animated: true, completion: nil)
    }
}


