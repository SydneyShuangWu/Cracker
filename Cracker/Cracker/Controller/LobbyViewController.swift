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
import FirebaseAuth

class LobbyViewController: UIViewController {
    
    let authManager = FirebaseAuthManager()
    
    @IBOutlet weak var animationView: AnimationView!
    
    @IBOutlet weak var crackCaseBtn: UIButton!
    
    @IBOutlet weak var createCaseBtn: UIButton!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
//        authManager.logOut()
        
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
    
    @IBAction func crackBtnDidTap(_ sender: Any) {
        
        NotificationCenter.default.addObserver(self, selector: #selector(navigateToSearchCaseVc), name: .loginDidSuccess, object: nil)
        
        if Auth.auth().currentUser?.uid != nil {
            
            navigateToSearchCaseVc()
            
        } else {
            
            authManager.performSignin(self)
        }
    }
    
    @objc func navigateToSearchCaseVc() {
        
        let vc = myStoryboard.instantiateViewController(withIdentifier: "SearchCaseVc")
        
        let nav = UINavigationController(rootViewController: vc)
        
        nav.modalPresentationStyle = .fullScreen

        nav.hero.isEnabled = true

        nav.hero.modalAnimationType = .autoReverse(presenting: .zoom)

        present(nav, animated: true, completion: nil)
    }

    @IBAction func createBtnDidTap(_ sender: Any) {
        
        NotificationCenter.default.addObserver(self, selector: #selector(navigateToSelectCategoryVc), name: .loginDidSuccess, object: nil)
        
        if Auth.auth().currentUser?.uid != nil {
            
            navigateToSelectCategoryVc()
            
        } else {
            
            authManager.performSignin(self)
        }
    }
    
    @objc func navigateToSelectCategoryVc() {
        
        let vc = myStoryboard.instantiateViewController(withIdentifier: "SelectCategoryVc")
        
        let nav = UINavigationController(rootViewController: vc)
        
        nav.modalPresentationStyle = .fullScreen

        nav.hero.isEnabled = true

        nav.hero.modalAnimationType = .autoReverse(presenting: .zoom)

        present(nav, animated: true, completion: nil)
    }
}

