//
//  LinearBoardViewController.swift
//  Cracker
//
//  Created by Sydney Wu on 2020/12/9.
//

import UIKit
import FirebaseAuth

protocol PassStageIndexDelegate: AnyObject {
    
    func getStageIndex(with index: Int)
}

class StageViewController: UIViewController {
    
    // UI
    @IBOutlet weak var stageTitle: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var storyLabel: UILabel!
    @IBOutlet weak var instructionLabel: UILabel!
    @IBOutlet weak var answerTF: UITextField!
    @IBOutlet weak var sendBtn: UIButton!
    @IBOutlet weak var stageHint: UILabel!
    @IBOutlet weak var hintLabel: UILabel!
    @IBOutlet weak var hintBtn: UIButton!
    
    // Data holder from ModeVc
    var gameId = ""
    var gameMode: Mode?
    
    // Firestore
    let firestoreManager = FirestoreManager.shared
    var crackerCase = CrackerCase()
    var stages = [CrackerStage]()
    
    // Track stage progress
    var currentStageIndex: Int!
    weak var delegate: PassStageIndexDelegate?
//    var hintCount = 0
    var storys: [String] = []
    var instructions: [String] = []
    var questions: [String] = []
    var answers: [String] = []
    var hints: [String] = []
    
    // Track stage records
    var stageRecord = CrackerStageRecord()
    var currentUid = Auth.auth().currentUser?.uid
    var currentPlayer = CrackerPlayer()
    var currentStageRecords = [CrackerStageRecord]()
    
    // Track final record
    var startTime: FIRTimestamp?
    var endTime: FIRTimestamp?
    var elapsedTimeString = ""
    var stageRecords = [CrackerStageRecord]()
    var winnerTeamId: String?

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setupUI()
        
        getStageData()
        
        fetchPlayerData()
        
        listenStageRecords()
    }
    
    override func viewWillAppear(_ animated: Bool) {

        super.viewWillAppear(animated)

        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    func setupUI() {
        
        sendBtn.setupCornerRadius()
        answerTF.setupCornerRadius()
    }
    
    // MARK: - Fetch stage data
    func getStageData() {
        
        let document = firestoreManager.getCollection(name: .crackerGame).document("\(gameId.prefix(20))").collection("CrackerCase")
        
        firestoreManager.read(collection: document, dataType: CrackerCase.self) { (result) in
            
            switch result {
            
            case .success(let crackerCase):
                
                self.crackerCase = crackerCase[0]
                self.stages = crackerCase[0].stages!
                
                for stage in self.stages {
                    
                    self.storys.append(stage.story)
                    self.instructions.append(stage.instruction)
                    self.questions.append(stage.question)
                    self.answers.append(stage.answer)
                    self.hints.append(stage.hint)
                }
                
                self.displayFirstStage()
                
            case .failure(let error):
                
                print("Failed to read cases: ", error.localizedDescription)
            }
        }
    }
    
    func displayFirstStage() {
        
        currentStageIndex = 1
        
        delegate?.getStageIndex(with: currentStageIndex)
        
        stageTitle.text = "Stage" + String(currentStageIndex)
        questionLabel.text = questions[currentStageIndex - 1]
        instructionLabel.text = instructions[currentStageIndex - 1]
        storyLabel.text = storys[currentStageIndex - 1]
    }
    
    func hideHint() {
        
        stageHint.isHidden = true
        hintLabel.isHidden = true
    }
    
    func showHint() {
        
        stageHint.isHidden = false
        hintLabel.isHidden = false
    }
    
    // MARK: - Crack case flow
    @IBAction func sendAnswer(_ sender: Any) {

        guard let text = answerTF.text else { return }
        
        for stageIndex in 1 ... stages.count where stageIndex == currentStageIndex {
                
            if text == answers[currentStageIndex - 1] && text != answers.last {
                
                // 👀 Track stage record
                self.saveToStageRecords()
 
                popupCorrectAnsAlert()
                answerTF.text = ""
                hintBtn.isEnabled = true
                
            } else if text == answers.last {
                
                // 👀 Track stage record
                self.saveToStageRecords()
                
                endTime = FIRTimestamp()
                
                popupFinishAlert()
                
            } else {
                
                popupWrongAnsAlert()
                answerTF.text = ""
                hintBtn.isEnabled = true
            }
        }
    }
    
    func popupCorrectAnsAlert() {
        
        let alert = UIAlertController(title: "答對了🥳", message: nil, preferredStyle: .alert)

        let nextStageAction = UIAlertAction(title: "查看下一關位置", style: .cancel) { _ in

            self.updateCurrentStageIndex()
            
            self.tabBarController?.selectedIndex = 1
        }

        alert.addAction(nextStageAction)

        present(alert, animated: true, completion: nil)
    }
    
    func popupWrongAnsAlert() {
        
        showAlert(withTitle: "答錯了🤧", withActionTitle: "我再想想", message: nil)
    }
    
    func popupFinishAlert() {
        
        let alert = UIAlertController(title: "成功破案😎", message: nil, preferredStyle: .alert)

        let nextStageAction = UIAlertAction(title: "查看破案成績", style: .cancel) { _ in
            
            let vc = myStoryboard.instantiateViewController(withIdentifier: "StageRecordVc") as! StageRecordViewController
            
            // Pass value
            vc.gameMode = self.gameMode
            self.calculateElapsedTime()
            vc.elapsedTimeString = self.elapsedTimeString
            
            let nav = UINavigationController(rootViewController: vc)
            
            nav.modalPresentationStyle = .fullScreen
            
            nav.hero.isEnabled = true
            
            nav.hero.modalAnimationType = .cover(direction: .up)
            
            self.saveFinalRecord()
            
            self.present(nav, animated: true, completion: nil)
        }

        alert.addAction(nextStageAction)

        present(alert, animated: true, completion: nil)
    }
    
    func updateCurrentStageIndex() {
        
        hideHint()
        
        currentStageIndex += 1
        
        delegate?.getStageIndex(with: currentStageIndex)
        
        if currentStageIndex <= stages.count {

            stageTitle.text = "Stage " + String(currentStageIndex)
            questionLabel.text = questions[currentStageIndex - 1]
            instructionLabel.text = instructions[currentStageIndex - 1]
            storyLabel.text = storys[currentStageIndex - 1]
            
        } else {
            
            sendBtn.isHidden = true
            answerTF.isHidden = true
        }
    }
    
    @IBAction func lookHint(_ sender: Any) {
        
//        hintCount += 1
        
        showHint()
        
        hintLabel.text = hints[currentStageIndex - 1]
        
        hintBtn.isEnabled = false
    }
    
    // MARK: - Track stage record
    func fetchPlayerData() {
        
        let document = firestoreManager.getCollection(name: .crackerGame).document("\(gameId.prefix(20))").collection("Players").document("\(currentUid!)")
        
        firestoreManager.readSingle(document, dataType: CrackerPlayer.self) { (result) in
            
            switch result {
            
            case .success(let crackerPlayer):
                
                self.currentPlayer = crackerPlayer
                
            
            case .failure(let error):
                
                print("Failed to read current user: ", error.localizedDescription)
            }
        }
    }
    
    func saveToStageRecords() {
        
        let stageRecords = firestoreManager.getCollection(name: .crackerGame).document("\(gameId.prefix(20))").collection("StageRecords").document()
        
        stageRecord.stagePassed = currentStageIndex
        stageRecord.teamId = currentPlayer.teamId
        stageRecord.playerId = currentUid!
        stageRecord.triggerTime = FIRTimestamp()
        
        firestoreManager.save(to: stageRecords, data: self.stageRecord)
    }
    
    // MARK: - Listen realtime stage status
    func listenStageRecords() {
        
        let stageRecords = firestoreManager.getCollection(name: .crackerGame).document(String(gameId.prefix(20))).collection("StageRecords")
        
        firestoreManager.listen(ref: stageRecords) { docs in
            
            self.firestoreManager.decode(CrackerStageRecord.self, documents: docs) { (result) in
                
                switch result {
                
                case .success(let stageRecords):
                    
                    self.currentStageRecords = stageRecords
                    self.filterStageRecords()
                    
                    self.queryWinnerTeam()
          
                case .failure(let error):
                    
                    print("Failed to read cases: ", error.localizedDescription)
                }
            }
        }
    }
    
    func filterStageRecords() {
        
        for stageRecord in currentStageRecords {
            
            if stageRecord.teamId == currentPlayer.teamId
                && (stageRecord.stagePassed + 1) > currentStageIndex {
                
                if (stageRecord.stagePassed) != stages.count {
                    
                    popupCorrectAnsAlert()
                    answerTF.text = ""
                    hintBtn.isEnabled = true
                    
                } else {
                    
                    popupFinishAlert()
                }
            }
        }
    }
    
    func calculateElapsedTime() {
        
        // Convert time
        let startTimeTS = startTime?.dateValue().timeIntervalSince1970
        let endTimeTS = endTime?.dateValue().timeIntervalSince1970
        let elapsedTimeInterval = (endTimeTS ?? 0) - (startTimeTS ?? 0)
        
        elapsedTimeString = String(format: "%02d:%02d:%02d", Int( elapsedTimeInterval / 3600), Int((elapsedTimeInterval / 60).truncatingRemainder(dividingBy: 60)), Int(elapsedTimeInterval.truncatingRemainder(dividingBy: 60)))
    }
    
    // MARK: - Query winner
    func checkBestStage(teamId: String) -> Int {
        
        for record in stageRecords where record.teamId == teamId {
                
            return record.stagePassed
        }
        
        return -1
    }
    
    func queryWinnerTeam() {

        let document = firestoreManager.getCollection(name: .crackerGame).document("\(gameId.prefix(20))").collection("StageRecords")
        
        firestoreManager.read(collection: document, dataType: CrackerStageRecord.self) { (result) in
            
            switch result {
            
            case .success(let stageRecords):
                
                self.stageRecords = stageRecords.sorted(by: { (first, second) -> Bool in
                    
                    return first.triggerTime.dateValue() < second.triggerTime.dateValue()
                })
                
//                let teamABestStage = self.checkBestStage(teamId: self.gameId + "A")
//                let teamBBestStage = self.checkBestStage(teamId: self.gameId + "B")
                
                let last = self.stages.count
                
                for record in self.stageRecords where record.stagePassed == last {
                    
                    if self.winnerTeamId == nil {
                        
                        print("only one")
                        
                        self.winnerTeamId = record.teamId
    
                    }
                }
                
                print("winner is ", self.winnerTeamId)
                
//                for record in self.stageRecords {
//
//                    if teamABestStage > teamBBestStage {
//
//                    } else if teamABestStage < teamBBestStage {
//
//                    } else {
//
//                    }
//                }
                
            case .failure(let error):
                
                print("Failed to read cases: ", error.localizedDescription)
            }
        }
    }
    
    func saveFinalRecord() {
        
        let document = firestoreManager.getCollection(name: .crackerGame).document("\(gameId.prefix(20))").collection("Players").document(currentUid!)
        
        currentPlayer.startTime = startTime ?? FIRTimestamp()
        
        currentPlayer.endTime = endTime ?? FIRTimestamp()
        
        currentPlayer.isWinner = winnerTeamId == currentPlayer.teamId ? true : false
        
        firestoreManager.save(to: document, data: currentPlayer)
    }
}

