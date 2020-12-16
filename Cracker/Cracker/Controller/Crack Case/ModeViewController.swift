//
//  ModeViewController.swift
//  Cracker
//
//  Created by Sydney Wu on 2020/12/7.
//

import UIKit

class ModeViewController: UIViewController {
    
    @IBOutlet weak var challengeTitle: UILabel!
    @IBOutlet weak var challengeQr: UIImageView!
    @IBOutlet weak var battleTopTitle: UILabel!
    @IBOutlet weak var battleBottomTitle: UILabel!
    @IBOutlet weak var battleTopQr: UIImageView!
    @IBOutlet weak var battleBottomQr: UIImageView!
    @IBOutlet weak var startBtn: UIButton!

    var gameMode: GameMode?
    
    var selectedCase: MockCase?
    
    var challengePageIsShown = true
    var battlePageIsShown = false

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setupNavBar()
        
        startBtn.setupCornerRadius()
        
        if challengePageIsShown == true {
            showChallengePage()
            hideBattlePage()
        } else {
            hideChallengePage()
            showBattlePage()
        }
    }
    
    func setupNavBar() {
        
        if gameMode == GameMode.challenge {
            setupNavigationBar(with: "CHALLENGE MODE")
        } else {
            setupNavigationBar(with: "BATTLE MODE")
        }

        setupCloseButton()
        setupBackButton()
    }
    
    func showChallengePage() {
        
        challengeTitle.isHidden = false
        challengeQr.isHidden = false
    }
    
    func hideChallengePage() {
        
        challengeTitle.isHidden = true
        challengeQr.isHidden = true
    }
    
    func showBattlePage() {
        
        battleTopTitle.isHidden = false
        battleTopQr.isHidden = false
        battleBottomTitle.isHidden = false
        battleBottomQr.isHidden = false
    }
    
    func hideBattlePage() {
        
        battleTopTitle.isHidden = true
        battleTopQr.isHidden = true
        battleBottomTitle.isHidden = true
        battleBottomQr.isHidden = true
    }
    
    @IBAction func navigateToBoardVc() {
        
        var vc: UIViewController
        
        if selectedCase?.category == CaseCategory.linear {
            
            vc = myStoryboard.instantiateViewController(withIdentifier: "LinearTabBar")
            
            // Set up delegate to pass stage index from stageVc to stageMapVc
            if let stageVC = (vc as? UITabBarController)?.viewControllers?.first as?
                StageViewController,
               let stageMapVC = (vc as? UITabBarController)?.viewControllers?[1] as? StageMapViewController {
                
                stageVC.delegate = stageMapVC
            }
            
        } else {
            
            vc = myStoryboard.instantiateViewController(withIdentifier: "RPGTabBar")
        }
        
        let nav = UINavigationController(rootViewController: vc)
        
        nav.modalPresentationStyle = .fullScreen
        
        nav.hero.isEnabled = true
        
        nav.hero.modalAnimationType = .autoReverse(presenting: .cover(direction: .up))

        present(nav, animated: true, completion: nil)
    }
}

