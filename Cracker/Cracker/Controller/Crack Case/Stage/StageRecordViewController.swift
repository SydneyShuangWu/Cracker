//
//  StageRecordViewController.swift
//  Cracker
//
//  Created by Sydney Wu on 2020/12/13.
//

import UIKit
import Lottie
import FirebaseAuth

class StageRecordViewController: UIViewController {
    
    // UI
    @IBOutlet weak var celebrateAnimation: AnimationView!
    @IBOutlet weak var lostAnimation: AnimationView!
    @IBOutlet weak var rateBtn: UIButton!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var totalTime: UILabel!
    
    // Data holder from StageVc
    var gameMode: Mode?
    var gameId = ""
    
    // Firestore
    let firestoreManager = FirestoreManager.shared
    var playerAfterGame = CrackerPlayer()
    let currentUid = Auth.auth().currentUser?.uid
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setupUI()
        
        fetchFinalRecord()
    }
    
    // MARK: - UI
    func setupUI() {
        
        setupNavigationBar(with: "Record")
        
        rateBtn.setupCornerRadius()
        backBtn.setupCornerRadius()
    }
    
    func playCelebrateAnimation() {
        
        celebrateAnimation.contentMode = .scaleAspectFit

        celebrateAnimation.loopMode = .loop
        
        celebrateAnimation.animationSpeed = 0.5
    
        celebrateAnimation.play()
    }
    
    func playLostAnimation() {
        
        lostAnimation.contentMode = .scaleAspectFit
        
        lostAnimation.animationSpeed = 1
    
        lostAnimation.play(fromProgress: 0.2, toProgress: 0.85, loopMode: .loop, completion: nil)
    }
    
    @IBAction func backToHome(_ sender: Any) {
        
        navigateToLobby()
    }
    
    // MARK: - Fetch final record
    func fetchFinalRecord() {
        
        let document = firestoreManager.getCollection(name: .crackerGame).document("\(gameId.prefix(20))").collection("Players").document("\(currentUid!)")
        
        firestoreManager.readSingle(document, dataType: CrackerPlayer.self) { (result) in
            
            switch result {
            
            case .success(let crackerPlayer):
                
                self.playerAfterGame = crackerPlayer
                self.fetchGameResult()
            
            case .failure(let error):
                
                print("Failed to read current user: ", error.localizedDescription)
            }
        }
    }
    
    func fetchGameResult() {
        
        totalTime.text = playerAfterGame.elapsedTimeString
        
        if playerAfterGame.isWinner == true {
            
            lostAnimation.isHidden = true
            celebrateAnimation.isHidden = false
            
            playCelebrateAnimation()
            
        } else {
            
            lostAnimation.isHidden = false
            celebrateAnimation.isHidden = true
            
            playLostAnimation()
        }
    }
}
