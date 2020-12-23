//
//  LinearBoardViewController.swift
//  Cracker
//
//  Created by Sydney Wu on 2020/12/9.
//

import UIKit

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
    
    // Track Stage Progress
    var currentStageIndex: Int!
    weak var delegate: PassStageIndexDelegate?
    var hintCount = 0
    var storys: [String] = []
    var instructions: [String] = []
    var questions: [String] = []
    var answers: [String] = []
    var hints: [String] = []
    
    // Firestore
    let firestoreManager = FirestoreManager.shared
    var crackerCase = CrackerCase()
    var stages = [CrackerStage]()

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setupUI()
        
        getStageData()
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
        
        let document = firestoreManager.getCollection(name: .crackerGame).document("\(gameId)").collection("CrackerCase")
        
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
    
    @IBAction func sendAnswer(_ sender: Any) {

        guard let text = answerTF.text else { return }
        
        for stageIndex in 1 ... stages.count where stageIndex == currentStageIndex {
                
            if text == answers[currentStageIndex - 1] && text != answers.last {
                
                popupCorrectAnsAlert()
                answerTF.text = ""
                hintBtn.isEnabled = true
                
                // Track stage record
                
            } else if text == answers.last {
                
                popupFinishAlert()
                
            } else {
                
                popupWrongAnsAlert()
                answerTF.text = ""
                hintBtn.isEnabled = true
            }
        }
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
            
            vc.hintCount = self.hintCount
            
            let nav = UINavigationController(rootViewController: vc)
            
            nav.modalPresentationStyle = .fullScreen
            
            nav.hero.isEnabled = true
            
            nav.hero.modalAnimationType = .cover(direction: .up)

            self.present(nav, animated: true, completion: nil)
        }

        alert.addAction(nextStageAction)

        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func lookHint(_ sender: Any) {
        
        hintCount += 1
        
        showHint()
        
        hintLabel.text = hints[currentStageIndex - 1]
        
        hintBtn.isEnabled = false
    }

}

