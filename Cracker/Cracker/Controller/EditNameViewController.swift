//
//  ChangeNameViewController.swift
//  Cracker
//
//  Created by Sydney Wu on 2020/12/20.
//

import UIKit

class EditNameViewController: UIViewController {
    
    @IBOutlet weak var editNameTF: UITextField!
    @IBOutlet weak var confirmBtn: UIButton!
    
    var didEditName: ((Bool, String?) -> Void)?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        setupUI()
    }
    
    func setupUI() {
        
        editNameTF.setupCornerRadius()
        editNameTF.setupTextFieldBorder()
        confirmBtn.setupCornerRadius()
    }
    
    @IBAction func closeBtnDidTap(_ sender: Any) {
        
        didEditName?(false, nil)
    }
    
    @IBAction func confirmBtnDidTap(_ sender: Any) {
        
        guard let editedName = editNameTF.text else { return }
        
        didEditName?(true, editedName)
    }
}
