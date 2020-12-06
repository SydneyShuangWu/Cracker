//
//  SidebarViewController.swift
//  Cracker
//
//  Created by Sydney Wu on 2020/12/1.
//

import UIKit

class SidebarViewController: UIViewController {

    override func viewDidLoad() {
        
        super.viewDidLoad()
    }
    
    @IBAction func navigateToProfilePage(_ sender: Any) {
        
        let vc = myStoryboard.instantiateViewController(withIdentifier: "ProfileVc")
        
        let nav = UINavigationController(rootViewController: vc)
        
        nav.modalPresentationStyle = .fullScreen

        nav.hero.isEnabled = true

        nav.hero.modalAnimationType = .autoReverse(presenting: .zoomSlide(direction: .right))

        present(nav, animated: true, completion: nil)
    }
}
