//
//  SelectModeViewController.swift
//  Cracker
//
//  Created by Sydney Wu on 2020/12/7.
//

import UIKit

class SelectModeViewController: UIViewController {
    
    var selectedGameMode: Mode?
    var challengePageIsShown = true
    var battlePageIsShown = false
    
    // Data holder for cases from CaseDetailVc
    var selectedCase: CrackerCase?
    var caseCategory: Category?
    
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
        navigateToModeVc()
    }
    
    @IBAction func selectBattle(_ sender: Any) {

        selectedGameMode = Mode.battle
        challengePageIsShown = false
        battlePageIsShown = true
        navigateToModeVc()
    }
    
    func navigateToModeVc() {

        let vc = myStoryboard.instantiateViewController(withIdentifier: "ModeVc") as! ModeViewController
        
        vc.gameMode = selectedGameMode
        vc.selectedCase = selectedCase
        vc.caseCategory = caseCategory
        
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

