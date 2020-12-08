//
//  StageViewCell.swift
//  Cracker
//
//  Created by Sydney Wu on 2020/12/8.
//

import UIKit

class StageViewCell: UITableViewCell {
    
    @IBOutlet weak var storyTV: UITextView!
    @IBOutlet weak var instructionTV: UITextView!
    @IBOutlet weak var questionTF: UITextField!
    @IBOutlet weak var answerTF: UITextField!
    @IBOutlet weak var hintTF: UITextField!
    @IBOutlet weak var longitudeTF: UITextField!
    @IBOutlet weak var latitudeTF: UITextField!
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        setupUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        
        super.setSelected(selected, animated: animated)
    }
    
    func setupUI() {
        
        storyTV.setupTextFieldBorder()
        storyTV.setupCornerRadius()
        
        instructionTV.setupTextFieldBorder()
        instructionTV.setupCornerRadius()
        
        questionTF.setupTextFieldBorder()
        questionTF.setupCornerRadius()
        
        answerTF.setupTextFieldBorder()
        answerTF.setupCornerRadius()
        
        hintTF.setupTextFieldBorder()
        hintTF.setupCornerRadius()
        
        longitudeTF.setupTextFieldBorder()
        longitudeTF.setupCornerRadius()
        
        latitudeTF.setupTextFieldBorder()
        latitudeTF.setupCornerRadius()        
    }
    
}
