//
//  StageRecordViewController.swift
//  Cracker
//
//  Created by Sydney Wu on 2020/12/13.
//

import UIKit
import Lottie

class StageRecordViewController: UIViewController {
    
    @IBOutlet weak var celebrateAnimation: AnimationView!
    @IBOutlet weak var rateBtn: UIButton!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var totalTime: UILabel!
    @IBOutlet weak var totalHintCount: UILabel!
    @IBOutlet weak var totalScore: UILabel!
    @IBOutlet weak var rankPercentage: UILabel!
    
    var hintCount: Int?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setupNavigationBar(with: "Record")
        
        playAnimation()
        
        rateBtn.setupCornerRadius()
        backBtn.setupCornerRadius()
        
        configureRecord()
    }
    
    func playAnimation() {
        
        celebrateAnimation.contentMode = .scaleAspectFit

        celebrateAnimation.loopMode = .loop
        
        celebrateAnimation.animationSpeed = 0.5
    
        celebrateAnimation.play()
    }
    
    @IBAction func backToHome(_ sender: Any) {
        
        let vc = myStoryboard.instantiateViewController(withIdentifier: "LobbyVc")
        
        let nav = UINavigationController(rootViewController: vc)
        
        nav.modalPresentationStyle = .fullScreen
        
        nav.hero.isEnabled = true
        
        nav.hero.modalAnimationType = .zoomOut

        present(nav, animated: true, completion: nil)
    }
    
    func configureRecord() {
        
        totalHintCount.text = String(hintCount!)
    }
}
