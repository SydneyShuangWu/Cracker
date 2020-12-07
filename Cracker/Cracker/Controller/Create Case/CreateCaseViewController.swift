//
//  CreateCaseViewController.swift
//  Cracker
//
//  Created by Sydney Wu on 2020/12/7.
//

import UIKit

class CreateCaseViewController: UIViewController {
    
    var caseCategory: CaseCategory?
    
    @IBOutlet weak var caseImage: UIImageView!
    @IBOutlet weak var caseNameTF: UITextField!
    @IBOutlet weak var caseLocationTF: UITextField!
    @IBOutlet weak var caseDurationTF: UITextField!
    @IBOutlet weak var startTimeTF: UITextField!
    @IBOutlet weak var endTimeTF: UITextField!
    @IBOutlet weak var minHeadCountTF: UITextField!
    @IBOutlet weak var maxHeadCountTF: UITextField!
    @IBOutlet weak var contentCountLabel: UILabel!
    @IBOutlet weak var contentCountTF: UITextField!
    @IBOutlet weak var openingTV: UITextView!
    @IBOutlet weak var continueBtn: UIButton!
    @IBOutlet weak var uploadBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar(with: "Create A Case")
        setupCloseButton()
        setupBackButton()
        
        setupUI()
        setupLabel()
    }
    
    func setupUI() {
        
        continueBtn.setupCornerRadius()
        
        openingTV.layer.borderWidth = 1.5
        openingTV.layer.borderColor = UIColor.systemGray.cgColor
    }
    
    func setupLabel() {
        
        if caseCategory == CaseCategory.linear {
            contentCountLabel.text = "關卡數量"
        } else {
            contentCountLabel.text = "NPC 數量"
        }
    }
    


}
