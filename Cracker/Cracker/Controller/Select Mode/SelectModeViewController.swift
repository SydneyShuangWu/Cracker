//
//  SelectModeViewController.swift
//  Cracker
//
//  Created by Sydney Wu on 2020/12/7.
//

import UIKit

enum GameMode: String {
    
    case challenge
    
    case battle
}

class SelectModeViewController: UIViewController {
    
    var gameMode: GameMode?
    var challengePageIsShown = true
    var battlePageIsShown = false
    
    @IBOutlet weak var challengeBtn: UIButton!
    @IBOutlet weak var battleBtn: UIButton!

    override func viewDidLoad() {
        
        super.viewDidLoad()

        setupNavBar()
        
        challengeBtn.setupCornerRadius()
        battleBtn.setupCornerRadius()
    }

    @IBAction func selectChallenge(_ sender: Any) {

        gameMode = GameMode.challenge
        challengePageIsShown = true
        battlePageIsShown = false
        navigateToModeVc()
    }
    
    @IBAction func selectBattle(_ sender: Any) {

        gameMode = GameMode.battle
        challengePageIsShown = false
        battlePageIsShown = true
        navigateToModeVc()
    }
    
    func navigateToModeVc() {

        let vc = myStoryboard.instantiateViewController(withIdentifier: "ModeVc") as! ModeViewController
        
        vc.gameMode = gameMode
        
        if challengePageIsShown == true {
            vc.challengePageIsShown = true
            vc.battlePageIsShown = false
        } else {
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

