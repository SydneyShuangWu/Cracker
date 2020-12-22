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
    
    @IBOutlet weak var teamIdTF: UITextField!
    @IBOutlet weak var confirmBtn: UIButton!
    
    var closeJoinTeam: ((Bool) -> Void)?
    let firestoreManager = FirestoreManager.shared
    var player = CrackerPlayer()
    
    weak var delegate: NavigateToGameDelegate?

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        confirmBtn.setupCornerRadius()
        teamIdTF.setupCornerRadius()
        teamIdTF.setupTextFieldBorder()
    }
    
    @IBAction func closeJoinTeamPage(_ sender: Any) {
        
        closeJoinTeam?(true)
    }
    
    @IBAction func joinBtnDidTap(_ sender: Any) {
        
        guard let joinGameId = teamIdTF.text else { return }
        
        let document = firestoreManager.getCollection(name: .crackerGame).document("\(joinGameId)")
        let newplayer = document.collection("Players").document(String(Auth.auth().currentUser!.uid))
        player.id = newplayer.documentID
        firestoreManager.save(to: newplayer, data: self.player)
        
        closeJoinTeam?(true)
        
        // Listen to game status. If game did start, navigate to game page        
        firestoreManager.getCollection(name: .crackerGame).document(joinGameId).addSnapshotListener { (documentSnapshot, error) in
            
            if let err = error {
                
                print(err)
            }
            
            guard let status = documentSnapshot?.data()?["gameDidStart"] as? Bool else { return }
            
            if status == true {
                
                print("😎 Game status fetched")
                
                self.delegate?.canNavigate(gameId: String(joinGameId))
            }
        }
    }
}
