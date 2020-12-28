//
//  StageBoardViewController.swift
//  Cracker
//
//  Created by Sydney Wu on 2020/12/27.
//

import UIKit
import FirebaseAuth
import Kingfisher

class StageBoardViewController: UIViewController {
    
    @IBOutlet weak var progressTableView: UITableView!
    
    // Data holder from ModeVc & SearchCaseVc
    var gameId = ""
    
    // Firestore
    let firestoreManager = FirestoreManager.shared
    var currentUid = Auth.auth().currentUser?.uid
    var stageRecords = [CrackerStageRecord]()
    var currentPlayer = CrackerPlayer()
    var allPlayers = [CrackerPlayer]()
    var stages = [CrackerStage]()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setupTableView()
        
        fetchAllPlayers()
        
        fetchStageData()
        
        fetchPlayerData()
    }
    
    func setupTableView() {
        
        progressTableView.delegate = self
        progressTableView.dataSource = self
    }
    
    // MARK: - Fetch stage data
    func fetchStageData() {
        
        let document = firestoreManager.getCollection(name: .crackerGame).document("\(gameId.prefix(20))").collection("CrackerCase")
        
        firestoreManager.read(collection: document, dataType: CrackerCase.self) { (result) in
            
            switch result {
            
            case .success(let crackerCase):
                
                self.stages = crackerCase[0].stages!
   
            case .failure(let error):
                
                print("Failed to read cases: ", error.localizedDescription)
            }
        }
    }
    
    // MARK: - Fetch player data
    func fetchPlayerData() {
        
        let document = firestoreManager.getCollection(name: .crackerGame).document("\(gameId.prefix(20))").collection("Players").document("\(currentUid!)")
        
        firestoreManager.readSingle(document, dataType: CrackerPlayer.self) { (result) in
            
            switch result {
            
            case .success(let crackerPlayer):
                
                self.currentPlayer = crackerPlayer
                
                self.listenStageRecords()
            
            case .failure(let error):
                
                print("Failed to read current user: ", error.localizedDescription)
            }
        }
    }
    
    // MARK: - Fetch all players
    func fetchAllPlayers() {
        
        let collection = firestoreManager.getCollection(name: .crackerGame).document("\(gameId.prefix(20))").collection("Players")
        
        firestoreManager.read(collection: collection, dataType: CrackerPlayer.self) { (result) in
            
            switch result {
            
            case .success(let allPlayers):
                
                self.allPlayers = allPlayers
      
            case .failure(let error):
                
                print("Failed to read cases: ", error.localizedDescription)
            }
        }
    }
    
    // MARK: - Listen realtime stage record
    func listenStageRecords() {
        
        let stageRecords = firestoreManager.getCollection(name: .crackerGame).document(String(gameId.prefix(20))).collection("StageRecords")
        
        firestoreManager.listen(ref: stageRecords) { docs in
            
            self.firestoreManager.decode(CrackerStageRecord.self, documents: docs) { (result) in
                
                switch result {
                
                case .success(let stageRecords):
                    
                    self.stageRecords = stageRecords
                    
                    self.stageRecords = stageRecords.sorted(by: { (first, second) -> Bool in
                        
                        return first.triggerTime.dateValue() < second.triggerTime.dateValue()
                    })
                    
                    self.progressTableView.reloadData()
          
                case .failure(let error):
                    
                    print("Failed to read cases: ", error.localizedDescription)
                }
            }
        }
    }
}

extension StageBoardViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return stageRecords.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var playerName = ""
        var playerImage = ""
        
        let records = stageRecords[indexPath.row]
        
        // Convert time
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let triggerTime = dateFormatter.string(from: records.triggerTime.dateValue())
        
        // Filter name and image
        for player in allPlayers where records.playerId == player.id {
        
            playerName = player.name
            playerImage = player.image
        }
        
        if records.teamId == currentPlayer.teamId {
            
            let teammatesCell = tableView.dequeueReusableCell(withIdentifier: "TeammatesTBCell") as! TeammatesTBCell
            
            teammatesCell.progressLabel.setupCornerRadius()
            teammatesCell.teammatesImageView.loadImage(playerImage)
            teammatesCell.teammatesImageView.layer.cornerRadius = teammatesCell.teammatesImageView.frame.size.width / 2
            
            teammatesCell.progressLabel.text = "我隊" + playerName + "已解出第" + "\(records.stagePassed)" + "關"
            
            teammatesCell.timeLabel.text = triggerTime
            
            return teammatesCell
            
        } else if records.teamId != currentPlayer.teamId {
            
            let opponentsCell = tableView.dequeueReusableCell(withIdentifier: "OpponentsTBCell") as! OpponentsTBCell
            
            opponentsCell.progressLabel.setupCornerRadius()
            opponentsCell.opponentsImageView.loadImage(playerImage)
            opponentsCell.opponentsImageView.layer.cornerRadius = opponentsCell.opponentsImageView.frame.size.width / 2
            
            if records.stagePassed == stages.count {
                
                opponentsCell.progressLabel.text = "敵隊" + playerName + "已解出最後一關，敵隊獲勝"
                
            } else {
                
                opponentsCell.progressLabel.text = "敵隊" + playerName + "已解出第" + "\(records.stagePassed)" + "關"
            }
            
            opponentsCell.timeLabel.text = triggerTime
            
            return opponentsCell
            
        } else {
            
            return UITableViewCell()
        }
    }
}
