//
//  StageRecordViewController.swift
//  Cracker
//
//  Created by Sydney Wu on 2020/12/13.
//

import UIKit
import Lottie

class StageRecordViewController: UIViewController {
    
    // UI
    @IBOutlet weak var celebrateAnimation: AnimationView!
    @IBOutlet weak var lostAnimation: AnimationView!
    @IBOutlet weak var rateBtn: UIButton!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var totalTime: UILabel!
    @IBOutlet weak var comparisonLabel: UILabel!
    
    // Data holder from StageVc
    var gameMode: Mode?
    var elapsedTimeString = ""
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setupUI()
    }
    
    func setupUI() {
        
        setupNavigationBar(with: "Record")
        
        rateBtn.setupCornerRadius()
        backBtn.setupCornerRadius()
        
        totalTime.text = elapsedTimeString
        
        if gameMode == Mode.challenge {
            
            playCelebrateAnimation()
            comparisonLabel.isHidden = true
            
        } else {
            
            comparisonLabel.isHidden = false
            
            // Win or lose
            
        }
    }
    
    func playCelebrateAnimation() {
        
        celebrateAnimation.contentMode = .scaleAspectFit

        celebrateAnimation.loopMode = .loop
        
        celebrateAnimation.animationSpeed = 0.5
    
        celebrateAnimation.play()
    }
    
    func playLostAnimation() {
        
        lostAnimation.contentMode = .scaleAspectFit
        
        lostAnimation.animationSpeed = 1.5
    
        lostAnimation.play(fromProgress: 0.26, toProgress: 0.8, loopMode: .loop, completion: nil)
    }
    
    @IBAction func backToHome(_ sender: Any) {
        
        navigateToLobby()
    }
}
