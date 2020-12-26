//
//  StageBoardViewController.swift
//  Cracker
//
//  Created by Sydney Wu on 2020/12/27.
//

import UIKit
import FirebaseAuth

class StageBoardViewController: UIViewController {
    
    @IBOutlet weak var progressTableView: UITableView!
    
    // Data holder from ModeVc & SearchCaseVc
    var gameId = ""
    
    // Firestore
    let firestoreManager = FirestoreManager.shared
    var currentUid = Auth.auth().currentUser?.uid
    var stageRecords = [CrackerStageRecord]()
    var currentPlayer = CrackerPlayer()
    var stages = [CrackerStage]()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setupTableView()
        
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
    
    // MARK: - Listen realtime stage record
    func listenStageRecords() {
        
        let stageRecords = firestoreManager.getCollection(name: .crackerGame).document(String(gameId.prefix(20))).collection("StageRecords")
        
        firestoreManager.listen(ref: stageRecords) { docs in
            
            self.firestoreManager.decode(CrackerStageRecord.self, documents: docs) { (result) in
                
                switch result {
                
                case .success(let stageRecords):
                    
                    self.stageRecords = stageRecords
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
        
        let records = stageRecords[indexPath.row]
        
        // Convert time
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let triggerTime = dateFormatter.string(from: records.triggerTime.dateValue())
        
        if records.teamId == currentPlayer.teamId {
            
            let teammatesCell = tableView.dequeueReusableCell(withIdentifier: "TeammatesTBCell") as! TeammatesTBCell
            
            teammatesCell.progressLabel.setupCornerRadius()
            
            teammatesCell.progressLabel.text = "我隊已解出第 " + "\(records.stagePassed)" + " 關"
            
            teammatesCell.timeLabel.text = triggerTime
            
            return teammatesCell
            
        } else if records.teamId != currentPlayer.teamId {
            
            let opponentsCell = tableView.dequeueReusableCell(withIdentifier: "OpponentsTBCell") as! OpponentsTBCell
            
            opponentsCell.progressLabel.setupCornerRadius()
            
            if records.stagePassed == stages.count {
                
                opponentsCell.progressLabel.text = "敵對已獲勝"
                
            } else {
                
                opponentsCell.progressLabel.text = "敵隊已解出第 " + "\(records.stagePassed)" + " 關"
            }
            
            opponentsCell.timeLabel.text = triggerTime
            
            return opponentsCell
            
        } else {
            
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 60
    }
}
