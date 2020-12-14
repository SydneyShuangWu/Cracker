//
//  ViewController.swift
//  Cracker
//
//  Created by Sydney Wu on 2020/11/27.
//

import Foundation
import UIKit
import Hero
import Lottie

class LobbyViewController: UIViewController {
    
    @IBOutlet weak var animationView: AnimationView!
    
    @IBOutlet weak var crackCaseBtn: UIButton!
    
    @IBOutlet weak var createCaseBtn: UIButton!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        playAnimation()
        
        setupButton()
    }
    
    func playAnimation() {
        
        animationView.contentMode = .scaleAspectFill

        animationView.loopMode = .loop
        
        animationView.animationSpeed = 0.5
    
        animationView.play()
    }
    
    func setupButton() {
        
        createCaseBtn.setupBorder()
        crackCaseBtn.setupBorder()
        
        createCaseBtn.setupCornerRadius()
        crackCaseBtn.setupCornerRadius()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: animated)
        
        playAnimation()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    @IBAction func navigateToSearchCaseVc(_ sender: Any) {
        
        let vc = myStoryboard.instantiateViewController(withIdentifier: "SearchCaseVc")
        
        let nav = UINavigationController(rootViewController: vc)
        
        nav.modalPresentationStyle = .fullScreen

        nav.hero.isEnabled = true

        nav.hero.modalAnimationType = .autoReverse(presenting: .zoom)

        present(nav, animated: true, completion: nil)
    }
    
    @IBAction func navigateToSelectCategoryVc(_ sender: Any) {
        
        let vc = myStoryboard.instantiateViewController(withIdentifier: "SelectCategoryVc")
        
        let nav = UINavigationController(rootViewController: vc)
        
        nav.modalPresentationStyle = .fullScreen

        nav.hero.isEnabled = true

        nav.hero.modalAnimationType = .autoReverse(presenting: .zoom)

        present(nav, animated: true, completion: nil)
    }
    
}

