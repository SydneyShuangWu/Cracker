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
    @IBOutlet weak var challengeQrCode: UIImageView!
    @IBOutlet weak var battleTopTitle: UILabel!
    @IBOutlet weak var battleTopQrCode: UIImageView!
    @IBOutlet weak var battleBottomTitle: UILabel!
    @IBOutlet weak var battleBottomQrCode: UIImageView!
    @IBOutlet weak var startBtn: UIButton!
    var challengePageIsShown = true
    var battlePageIsShown = false
    
    // Data holder for cases from SelectModeVc
    var gameMode: Mode?
    var selectedCase: CrackerCase?
    var gameId = ""
    var teams: [String] = []
    
    // Firebase
    let firestoreManager = FirestoreManager.shared
    var startTime: FIRTimestamp?

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
            setupNavigationBar(with: "Challenge Mode")
        } else {
            setupNavigationBar(with: "Battle Mode")
        }

        setupCloseButton()
        setupBackButton()
    }
    
    func generateQRCode(from string: String) -> UIImage? {
        
        let data = string.data(using: String.Encoding.ascii)

        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            
            filter.setValue(data, forKey: "inputMessage")
            
            let transform = CGAffineTransform(scaleX: 10, y: 10)

            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }

        return nil
    }
    
    func showChallengePage() {
        
        challengeTitle.isHidden = false
        challengeQrCode.isHidden = false
        
        challengeQrCode.image = generateQRCode(from: gameId + "A")
    }
    
    func hideChallengePage() {
        
        challengeTitle.isHidden = true
        challengeQrCode.isHidden = true
    }
    
    func showBattlePage() {
        
        battleTopTitle.isHidden = false
        battleTopQrCode.isHidden = false
        battleTopQrCode.image = generateQRCode(from: teams[0])
        
        battleBottomTitle.isHidden = false
        battleBottomQrCode.isHidden = false
        battleBottomQrCode.image = generateQRCode(from: teams[1])
    }
    
    func hideBattlePage() {
        
        battleTopTitle.isHidden = true
        battleTopQrCode.isHidden = true
        battleBottomTitle.isHidden = true
        battleBottomQrCode.isHidden = true
    }
    
    @IBAction func startCracking() {
        
        // Change gameDidStart to true
        self.firestoreManager.update(collectionName: .crackerGame, documentId: "\(self.gameId.prefix(20))", fields: ["gameDidStart" : true])
        
        // Post start time
        self.firestoreManager.update(collectionName: .crackerGame, documentId: "\(self.gameId.prefix(20))", fields: ["startTime" : FIRTimestamp()])
        
        navigateToGamePage()
    }
    
    func navigateToGamePage() {
        
        var vc: UIViewController
        
        if selectedCase?.category == Category.linear.rawValue {
            
            vc = myStoryboard.instantiateViewController(withIdentifier: "LinearTabBar")
            
            // Set up delegate to pass stage index from stageVc to stageMapVc
            if let stageVC = (vc as? UITabBarController)?.viewControllers?.first as?
                StageViewController,
               let stageMapVC = (vc as? UITabBarController)?.viewControllers?[1] as? StageMapViewController,
               let stageBoardVC = (vc as? UITabBarController)?.viewControllers?[2] as? StageBoardViewController {
                
                stageVC.delegate = stageMapVC
                stageVC.gameId = gameId
                stageVC.gameMode = gameMode
                
                stageMapVC.gameId = gameId
                
                stageBoardVC.gameId = gameId
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

