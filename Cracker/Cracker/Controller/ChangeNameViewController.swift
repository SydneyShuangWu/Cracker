//
//  ChangeNameViewController.swift
//  Cracker
//
//  Created by Sydney Wu on 2020/12/20.
//

import UIKit

class EditNameViewController: UIViewController {
    
    @IBOutlet weak var changeNameTF: UITextField!
    @IBOutlet weak var confirmBtn: UIButton!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        setupUI()
    }
    
    func setupUI() {
        
        changeNameTF.setupCornerRadius()
        changeNameTF.setupTextFieldBorder()
        confirmBtn.setupCornerRadius()
    }
    
    @IBAction func closeBtnDidTap(_ sender: Any) {
    }
    
    @IBAction func confirmBtnDidTap(_ sender: Any) {
    }
}
