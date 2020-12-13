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
    
    @IBOutlet weak var stageTitle: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var storyLabel: UILabel!
    @IBOutlet weak var instructionLabel: UILabel!
    @IBOutlet weak var answerTF: UITextField!
    @IBOutlet weak var sendBtn: UIButton!
    @IBOutlet weak var stageHint: UILabel!
    @IBOutlet weak var hintLabel: UILabel!
    @IBOutlet weak var finishBtn: UIButton!
    @IBOutlet weak var hintBtn: UIButton!
    
    var ids: [String] = []
    var storys: [String] = []
    var instructions: [String] = []
    var questions: [String] = []
    var answers: [String] = []
    var hints: [String] = []
    
    let stageCount = testLinearCase.stageContent?.count
    var currentStageIndex: Int!
    
    weak var delegate: PassStageIndexDelegate?

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setupUI()
        
        getStageData()
        
        displayFirstStage()
    }
    
    override func viewWillAppear(_ animated: Bool) {

        super.viewWillAppear(animated)

        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    func setupUI() {
        
        sendBtn.setupCornerRadius()
        answerTF.setupCornerRadius()
        finishBtn.setupCornerRadius()
    }
    
    func getStageData() {
        
        guard let stageContents = testLinearCase.stageContent else { return }
        
        for stageContent in stageContents {
            
            ids.append(stageContent.id)
            storys.append(stageContent.story)
            instructions.append(stageContent.instruction)
            questions.append(stageContent.question)
            answers.append(stageContent.answer)
            hints.append(stageContent.hint)
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
        
        for id in ids {

            if id == String(currentStageIndex) {
                
                if text == answers[currentStageIndex - 1] && text != answers.last {
                    
                    popupCorrectAnsAlert()
                    answerTF.text = ""
                    hintBtn.isEnabled = true
                 
                } else if text == answers.last {
                    
                    popupFinishAlert()
                    
                } else {
                    
                    popupWrongAnsAlert()
                    answerTF.text = ""
                    hintBtn.isEnabled = true
                }
            }
        }
    }
    
    func runStageFlow() {
        
        hideHint()
        
        currentStageIndex += 1
        
        delegate?.getStageIndex(with: currentStageIndex)
        
        if currentStageIndex <= stageCount! {
    
            stageTitle.text = "Stage " + String(currentStageIndex)
            questionLabel.text = questions[currentStageIndex - 1]
            instructionLabel.text = instructions[currentStageIndex - 1]
            storyLabel.text = storys[currentStageIndex - 1]
            
        } else {
            
            sendBtn.isHidden = true
            answerTF.isHidden = true
            finishBtn.isHidden = false
        }
    }
    
    func popupCorrectAnsAlert() {
        
        let alert = UIAlertController(title: "答對了🥳", message: nil, preferredStyle: .alert)

        let nextStageAction = UIAlertAction(title: "查看下一關位置", style: .cancel) { _ in

            self.runStageFlow()
        }

        alert.addAction(nextStageAction)

        present(alert, animated: true, completion: nil)
    }
    
    func popupWrongAnsAlert() {
        
        showAlert(withTitle: "答錯了🤧", withActionTitle: "我再想想", message: nil)
    }
    
    func popupFinishAlert() {
        
        let alert = UIAlertController(title: "Case successfully cracked!", message: nil, preferredStyle: .alert)

        let nextStageAction = UIAlertAction(title: "Yeah", style: .cancel) { _ in

            let vc = myStoryboard.instantiateViewController(withIdentifier: "LobbyVc")
            
            let nav = UINavigationController(rootViewController: vc)
            
            nav.modalPresentationStyle = .fullScreen
            
            nav.hero.isEnabled = true
            
            self.present(nav, animated: true, completion: nil)
        }

        alert.addAction(nextStageAction)

        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func lookHint(_ sender: Any) {
        
        showHint()
        
        hintLabel.text = hints[currentStageIndex - 1]
        
        hintBtn.isEnabled = false
    }

}

