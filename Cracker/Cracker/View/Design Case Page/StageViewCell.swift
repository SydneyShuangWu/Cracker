//
//  StageViewCell.swift
//  Cracker
//
//  Created by Sydney Wu on 2020/12/8.
//

import UIKit

class StageViewCell: UITableViewCell {
    
    var stage = CrackerStage()
    
    var callback: ((CrackerStage) -> Void)?
    
    @IBOutlet weak var storyTV: UITextView!
    @IBOutlet weak var instructionTV: UITextView!
    @IBOutlet weak var questionTF: UITextField!
    @IBOutlet weak var answerTF: UITextField!
    @IBOutlet weak var hintTF: UITextField!
    @IBOutlet weak var longitudeTF: UITextField!
    @IBOutlet weak var latitudeTF: UITextField!
    @IBOutlet weak var locationNameTF: UITextField!
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        setupStageTextField()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        
        super.setSelected(selected, animated: animated)
    }
    
    func setupStageTextField() {
        
        storyTV.setupTextFieldBorder()
        storyTV.setupCornerRadius()
        storyTV.delegate = self
        
        instructionTV.setupTextFieldBorder()
        instructionTV.setupCornerRadius()
        instructionTV.delegate = self
        
        questionTF.setupTextFieldBorder()
        questionTF.setupCornerRadius()
        questionTF.delegate = self
        
        answerTF.setupTextFieldBorder()
        answerTF.setupCornerRadius()
        answerTF.delegate = self
        
        hintTF.setupTextFieldBorder()
        hintTF.setupCornerRadius()
        hintTF.delegate = self
        
        longitudeTF.setupTextFieldBorder()
        longitudeTF.setupCornerRadius()
        longitudeTF.delegate = self
        
        latitudeTF.setupTextFieldBorder()
        latitudeTF.setupCornerRadius()
        latitudeTF.delegate = self
        
        locationNameTF.setupTextFieldBorder()
        locationNameTF.setupCornerRadius()
        locationNameTF.delegate = self
    }
    
    func getStageData() {
        
        guard let story = storyTV.text,
              let instruction = instructionTV.text,
              let question = questionTF.text,
              let answer = answerTF.text,
              let hint = hintTF.text,
              let longitude = longitudeTF.text,
              let latitude = latitudeTF.text,
              let locationName = locationNameTF.text
        
        else { return }
        
        stage.story = story
        stage.instruction = instruction
        stage.question = question
        stage.answer = answer
        stage.hint = hint
        stage.longitude = Double(longitude) ?? 0
        stage.latitude = Double(latitude) ?? 0
        stage.locationName = locationName
        
        if !story.isEmpty, !instruction.isEmpty, !question.isEmpty, !answer.isEmpty, !hint.isEmpty, !longitude.isEmpty, !latitude.isEmpty, !locationName.isEmpty {
            
            callback?(stage)
        }
    }
}

extension StageViewCell: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        getStageData()
    }
}

extension StageViewCell: UITextViewDelegate {
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        getStageData()
    }
}
