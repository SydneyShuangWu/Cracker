//
//  CaseDetailViewController.swift
//  Cracker
//
//  Created by Sydney Wu on 2020/12/4.
//

import UIKit
import FirebaseAuth

class CaseDetailViewController: UIViewController {
    
    @IBOutlet weak var caseDetailTableView: UITableView!
    @IBOutlet weak var crackCaseBtn: UIButton!
    
    // Data holder for cases from SearchCaseVC
    var selectedCase: CrackerCase?
    var caseCategory: Category?
    
    // Firebase
    let firestoreManager = FirestoreManager.shared
    let authManager = FirebaseAuthManager()
    var crackerGame = CrackerGame()
    var firstPlayer = CrackerPlayer()
    var gameId = ""

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(navigateToSelectModeVc), name: .loginDidSuccess, object: nil)
        
        setupTableView()
        
        crackCaseBtn.setupCornerRadius()
        
        setupNavigationBar(with: selectedCase!.name)
        setupCloseButton()
        setupBackButton()
    }
    
    func setupTableView() {
        
        caseDetailTableView.delegate = self
        caseDetailTableView.dataSource = self
    }
    
    @IBAction func crackThisCase(_ sender: Any) {
        
        if Auth.auth().currentUser?.uid != nil {
            
            createNewGame()
            navigateToSelectModeVc()
            
        } else {
            
            authManager.performSignin(self)
        }
    }
    
    @objc func navigateToSelectModeVc() {
        
        let vc = myStoryboard.instantiateViewController(withIdentifier: "SelectModeVc") as! SelectModeViewController
        
        vc.selectedCase = selectedCase
        vc.caseCategory = caseCategory
        vc.gameId = gameId
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - Firestore
    func createNewGame() {
        
        let document = firestoreManager.getCollection(name: .crackerGame).document()
        
        crackerGame.id = document.documentID
        gameId = document.documentID
        
        // Create Case Collection
        let crackerCase = document.collection("CrackerCase").document(String(selectedCase!.id))
        firestoreManager.save(to: crackerCase, data: selectedCase)
        
        // Create Players collection
        firstPlayer.id = Auth.auth().currentUser!.uid
        let players = document.collection("Players").document(String(firstPlayer.id))
        firestoreManager.save(to: players, data: self.firstPlayer)
        
        // Save
        self.firestoreManager.save(to: document, data: self.crackerGame)
    }
}

extension CaseDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let caseImageCell = tableView.dequeueReusableCell(withIdentifier: "CaseImageTBCell") as! CaseImageTBCell
        let caseIntroCell = tableView.dequeueReusableCell(withIdentifier: "CaseIntroTBCell") as! CaseIntroTBCell
        let caseScoreCell = tableView.dequeueReusableCell(withIdentifier: "CaseScoreTBCell") as! CaseScoreTBCell
        let caseDescriptionCell = tableView.dequeueReusableCell(withIdentifier: "CaseDescriptionTBCell") as! CaseDescriptionTBCell
        
        switch indexPath.row {
        
        case 0:
            caseImageCell.setupCaseImageWith(cases: selectedCase!)
            return caseImageCell
            
        case 1:
            caseIntroCell.setupCaseLocationWith(cases: selectedCase!)
            return caseIntroCell
            
        case 2:
            caseIntroCell.setupCaseTimeWith(cases: selectedCase!)
            return caseIntroCell
            
        case 3:
            caseIntroCell.setupCaseDurationWith(cases: selectedCase!)
            return caseIntroCell
            
        case 4:
            caseIntroCell.setupCaseHeadCountWith(cases: selectedCase!)
            return caseIntroCell
            
        case 5:
            caseScoreCell.setupCaseScoreWith(cases: selectedCase!)
            return caseScoreCell
            
        default:
            caseDescriptionCell.setupCaseDescriptionWith(cases: selectedCase!)
            return caseDescriptionCell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.row {
        
        case 0:
            return 220
        case 6:
            return UITableView.automaticDimension
        default:
            return 40
        }
    }    
}
