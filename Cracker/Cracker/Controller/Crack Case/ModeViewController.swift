//
//  ModeViewController.swift
//  Cracker
//
//  Created by Sydney Wu on 2020/12/7.
//

import UIKit

class ModeViewController: UIViewController {
    
    @IBOutlet weak var challengeTitle: UILabel!
    @IBOutlet weak var challengeId: UILabel!
    @IBOutlet weak var battleTopTitle: UILabel!
    @IBOutlet weak var battleTopId: UILabel!
    @IBOutlet weak var battleBottomTitle: UILabel!
    @IBOutlet weak var battleBottomId: UILabel!
    @IBOutlet weak var startBtn: UIButton!

    // Data holder for cases from SelectModeVc
    var gameMode: Mode?
    var selectedCase: CrackerCase?
    var caseCategory: Category?
    
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
        
        if gameMode == Mode.challenge {
            setupNavigationBar(with: "CHALLENGE MODE")
        } else {
            setupNavigationBar(with: "BATTLE MODE")
        }

        setupCloseButton()
        setupBackButton()
    }
    
    func showChallengePage() {
        
        challengeTitle.isHidden = false
        challengeId.isHidden = false
    }
    
    func hideChallengePage() {
        
        challengeTitle.isHidden = true
        challengeId.isHidden = true
    }
    
    func showBattlePage() {
        
        battleTopTitle.isHidden = false
        battleTopId.isHidden = false
        battleBottomTitle.isHidden = false
        battleBottomId.isHidden = false
    }
    
    func hideBattlePage() {
        
        battleTopTitle.isHidden = true
        battleTopId.isHidden = true
        battleBottomTitle.isHidden = true
        battleBottomId.isHidden = true
    }
    
    @IBAction func navigateToMainVc() {
        
        var vc: UIViewController
        
        if caseCategory == Category.linear {
            
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

