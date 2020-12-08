//
//  RPGViewCell.swift
//  Cracker
//
//  Created by Sydney on 2020/12/8.
//

import UIKit

class RPGViewCell: UITableViewCell {
    
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var locationTF: UITextField!
    @IBOutlet weak var longitudeTF: UITextField!
    @IBOutlet weak var latitudeTF: UITextField!
    @IBOutlet weak var talkTF: UITextField!
    @IBOutlet weak var triggerTF: UITextField!
    @IBOutlet weak var clueTF: UITextField!
    @IBOutlet weak var infoTV: UITextView!
    
    override func awakeFromNib() {
        
        super.awakeFromNib()

        setupUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        
        super.setSelected(selected, animated: animated)

    }
    
    func setupUI() {
        
        nameTF.setupTextFieldBorder()
        nameTF.setupCornerRadius()
        
        locationTF.setupTextFieldBorder()
        locationTF.setupCornerRadius()
        
        longitudeTF.setupTextFieldBorder()
        longitudeTF.setupCornerRadius()
        
        latitudeTF.setupTextFieldBorder()
        latitudeTF.setupCornerRadius()
        
        talkTF.setupTextFieldBorder()
        talkTF.setupCornerRadius()
        
        triggerTF.setupTextFieldBorder()
        triggerTF.setupCornerRadius()
        
        clueTF.setupTextFieldBorder()
        clueTF.setupCornerRadius()
        
        infoTV.setupTextFieldBorder()
        infoTV.setupCornerRadius()
    }
    
}
