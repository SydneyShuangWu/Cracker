//
//  JoinTeamViewController.swift
//  Cracker
//
//  Created by Sydney Wu on 2020/12/19.
//

import UIKit
import FirebaseAuth

protocol NavigateToGameDelegate: AnyObject {
    
    func canNavigate(gameId: String)
}

class JoinTeamViewController: UIViewController {
    
    // UI
    @IBOutlet weak var teamIdTF: UITextField!
    @IBOutlet weak var confirmBtn: UIButton!
    
    // Pass value
    var closeJoinTeam: ((Bool) -> Void)?
    weak var delegate: NavigateToGameDelegate?
    
    // Firebase
    let firestoreManager = FirestoreManager.shared
    var player = CrackerPlayer()
    var currentUid = Auth.auth().currentUser?.uid
    var currentUser = CrackerUser(id: "")

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        confirmBtn.setupCornerRadius()
        teamIdTF.setupCornerRadius()
        teamIdTF.setupTextFieldBorder()
        
        fetchUserData()
    }
    
    @IBAction func closeJoinTeamPage(_ sender: Any) {
        
        closeJoinTeam?(true)
    }
    
    func fetchUserData() {
        
        let document = firestoreManager.getCollection(name: .crackerUser).document(currentUid!)
        
        firestoreManager.readSingle(document, dataType: CrackerUser.self) { (result) in
            
            switch result {
            
            case .success(let crackerUser):
                
                self.currentUser = crackerUser
                
                // Save user data to player
                let newplayer = document.collection("Players").document(self.currentUid!)
                self.player.image = self.currentUser.image
                self.player.name = self.currentUser.name
                self.firestoreManager.save(to: newplayer, data: self.player)
            
            case .failure(let error):
                
                print("Failed to read current user: ", error.localizedDescription)
            }
        }
    }
    
    @IBAction func joinBtnDidTap(_ sender: Any) {
        
        guard let joinGameId = teamIdTF.text else { return }
        
        let document = firestoreManager.getCollection(name: .crackerGame).document("\(joinGameId.prefix(20))")
        
        // Save teammates as players
        let newplayer = document.collection("Players").document(currentUid!)
        player.id = newplayer.documentID
        player.teamId = joinGameId
        firestoreManager.save(to: newplayer, data: self.player)
        
        closeJoinTeam?(true)
        
        // Listen to game status
        firestoreManager.getCollection(name: .crackerGame).document("\(joinGameId.prefix(20))").addSnapshotListener { (documentSnapshot, error) in
            
            guard let status = documentSnapshot?.data()?["gameDidStart"] as? Bool else { return }
            
            if status == true {
                
                print("😎 Game status fetched")
                
                self.delegate?.canNavigate(gameId: String(joinGameId.prefix(20)))
            }
            
            if let err = error {
                
                print(err)
            }
        }
    }
}
