//
//  DesignTestTBCell.swift
//  Cracker
//
//  Created by Sydney on 2020/12/14.
//

import Foundation
import UIKit

class DesignTestTBCell: UITableViewCell {
    
    @IBOutlet weak var questionTF: UITextField!
    @IBOutlet weak var choiceTF: UITextField!
    @IBOutlet weak var answerTF: UITextField!
    
    func setupCellUI() {
        
        questionTF.setupCornerRadius()
        questionTF.setupTextFieldBorder()
        
        choiceTF.setupCornerRadius()
        choiceTF.setupTextFieldBorder()
        
        answerTF.setupCornerRadius()
        answerTF.setupTextFieldBorder()
    }
}
