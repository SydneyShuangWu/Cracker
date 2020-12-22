//
//  ModeViewController.swift
//  Cracker
//
//  Created by Sydney Wu on 2020/12/7.
//

import UIKit

class ModeViewController: UIViewController {
    
    // UI
    @IBOutlet weak var challengeTitle: UILabel!
    @IBOutlet weak var challengeId: UILabel!
    @IBOutlet weak var battleTopTitle: UILabel!
    @IBOutlet weak var battleTopId: UILabel!
    @IBOutlet weak var battleBottomTitle: UILabel!
    @IBOutlet weak var battleBottomId: UILabel!
    @IBOutlet weak var startBtn: UIButton!
    var challengePageIsShown = true
    var battlePageIsShown = false
    
    // Data holder for cases from SelectModeVc
    var gameMode: Mode?
    var selectedCase: CrackerCase?
    var caseCategory: Category?
    var gameId = ""
    var teams: [String] = []
    
    // Firebase
    let firestoreManager = FirestoreManager.shared

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
        challengeId.text = gameId
    }
    
    func hideChallengePage() {
        
        challengeTitle.isHidden = true
        challengeId.isHidden = true
    }
    
    func showBattlePage() {
        
        battleTopTitle.isHidden = false
        battleTopId.isHidden = false
        battleTopId.text = teams[0]
        
        battleBottomTitle.isHidden = false
        battleBottomId.isHidden = false
        battleBottomId.text = teams[1]
    }
    
    func hideBattlePage() {
        
        battleTopTitle.isHidden = true
        battleTopId.isHidden = true
        battleBottomTitle.isHidden = true
        battleBottomId.isHidden = true
    }
    
    @IBAction func startCracking() {
        
        // Change gameDidStart to true
        self.firestoreManager.update(collectionName: .crackerGame, documentId: self.gameId, fields: ["gameDidStart" : true])
        
        // Post start time
        self.firestoreManager.update(collectionName: .crackerGame, documentId: self.gameId, fields: ["startTime" : FIRTimestamp()])
        
        navigateToGamePage()
    }
    
    func navigateToGamePage() {
        
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
            
//            vc = myStoryboard.instantiateViewController(withIdentifier: "RPGTabBar")
            
            // MARK: - Modification Required
            vc = myStoryboard.instantiateViewController(withIdentifier: "LinearTabBar")
            
            // Set up delegate to pass stage index from stageVc to stageMapVc
            if let stageVC = (vc as? UITabBarController)?.viewControllers?.first as?
                StageViewController,
               let stageMapVC = (vc as? UITabBarController)?.viewControllers?[1] as? StageMapViewController {
                
                stageVC.delegate = stageMapVC
            }
        }
        
        let nav = UINavigationController(rootViewController: vc)
        
        nav.modalPresentationStyle = .fullScreen
        
        nav.hero.isEnabled = true
        
        nav.hero.modalAnimationType = .autoReverse(presenting: .cover(direction: .up))

        present(nav, animated: true, completion: nil)
    }
}

