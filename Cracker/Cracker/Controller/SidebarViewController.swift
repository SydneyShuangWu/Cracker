//
//  SidebarViewController.swift
//  Cracker
//
//  Created by Sydney Wu on 2020/12/1.
//

import UIKit
import FirebaseAuth

class SidebarViewController: UIViewController {
    
    let authManager = FirebaseAuthManager()

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(navigateToProfileVc), name: .loginDidSuccess, object: nil)
    }
    
    @IBAction func profileBtnDidTap(_ sender: Any) {
        
        if Auth.auth().currentUser?.uid != nil {
            
            navigateToProfileVc()
            
        } else {
            
            authManager.performSignin(self)
        }
    }
    
    @objc func navigateToProfileVc() {
        
        let vc = myStoryboard.instantiateViewController(withIdentifier: "ProfileVc")
        
        let nav = UINavigationController(rootViewController: vc)
        
        nav.modalPresentationStyle = .fullScreen

        nav.hero.isEnabled = true

        nav.hero.modalAnimationType = .autoReverse(presenting: .zoomSlide(direction: .right))

        present(nav, animated: true, completion: nil)
    }
    
    @IBAction func privacyBtnDidTap(_ sender: Any) {
        
        navigateToPrivacyVc()
//        fatalError()
    }
    
    @objc func navigateToPrivacyVc() {
        
        let vc = myStoryboard.instantiateViewController(withIdentifier: "PrivacyVc")
        
        let nav = UINavigationController(rootViewController: vc)
        
        nav.modalPresentationStyle = .fullScreen

        nav.hero.isEnabled = true

        nav.hero.modalAnimationType = .autoReverse(presenting: .zoomSlide(direction: .right))

        present(nav, animated: true, completion: nil)
    }
    
}
