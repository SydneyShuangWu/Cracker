//
//  SelectModeViewController.swift
//  Cracker
//
//  Created by Sydney Wu on 2020/12/7.
//

import UIKit

class SelectModeViewController: UIViewController {
    
    // Mode VC UI
    var selectedGameMode: Mode?
    var challengePageIsShown = true
    var battlePageIsShown = false
    
    // Data holder for cases from CaseDetailVc
    var selectedCase: CrackerCase?
    var gameId = ""
    var teams: [String] = []
    
    // Firebase
    let firestoreManager = FirestoreManager.shared
    
    // UI
    @IBOutlet weak var challengeBtn: UIButton!
    @IBOutlet weak var battleBtn: UIButton!

    override func viewDidLoad() {
        
        super.viewDidLoad()

        setupNavBar()
        
        challengeBtn.setupCornerRadius()
        battleBtn.setupCornerRadius()
    }

    @IBAction func selectChallenge(_ sender: Any) {

        selectedGameMode = Mode.challenge
        challengePageIsShown = true
        battlePageIsShown = false
        
        // Post game mode to Firestore
        self.firestoreManager.update(collectionName: .crackerGame, documentId: self.gameId, fields: ["gameMode" : selectedGameMode!.rawValue])
        
        navigateToModeVc()
    }
    
    @IBAction func selectBattle(_ sender: Any) {

        selectedGameMode = Mode.battle
        challengePageIsShown = false
        battlePageIsShown = true
        
        // Post game mode to Firestore
        self.firestoreManager.update(collectionName: .crackerGame, documentId: self.gameId, fields: ["gameMode" : selectedGameMode!.rawValue])
        
        // Post team ids to Firestore
        let teams = ["\(gameId)" + "A", "\(gameId)" + "B"]
        self.teams = teams
        
        self.firestoreManager.update(collectionName: .crackerGame, documentId: self.gameId, fields: ["teams" : teams])
        
        navigateToModeVc()
    }
    
    func navigateToModeVc() {

        let vc = myStoryboard.instantiateViewController(withIdentifier: "ModeVc") as! ModeViewController
        
        vc.gameMode = selectedGameMode
        vc.selectedCase = selectedCase
        
        if challengePageIsShown == true {
            
            vc.gameId = gameId
            vc.challengePageIsShown = true
            vc.battlePageIsShown = false
            
        } else {
            
            vc.teams = teams
            vc.challengePageIsShown = false
            vc.battlePageIsShown = true
        }

        navigationController?.pushViewController(vc, animated: true)
    }
    
    func setupNavBar() {
        
        setupNavigationBar(with: "Select Case Mode")
        setupBackButton()
        setupCloseButton()
    }
}

