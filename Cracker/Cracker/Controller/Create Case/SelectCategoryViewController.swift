//
//  SelectCategoryViewController.swift
//  Cracker
//
//  Created by Sydney Wu on 2020/12/7.
//

import UIKit

class SelectCategoryViewController: UIViewController {
    
    @IBOutlet weak var linearBtn: UIButton!
    @IBOutlet weak var rpgBtn: UIButton!
    
    var selectedCategory: CaseCategory?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar(with: "Select Category")
        setupCloseButton()

        linearBtn.setupCornerRadius()
        rpgBtn.setupCornerRadius()
    }
    
    @IBAction func selectLinear(_ sender: Any) {
        
        selectedCategory = CaseCategory.linear
        navigateToCreateCaseVc()
    }
    
    @IBAction func selectRpg(_ sender: Any) {
        
        showAlert(withTitle: "Coming soon!", withActionTitle: "OK", message: nil)
        
//        selectedCategory = CaseCategory.rpg
//        navigateToCreateCaseVc()
    }
    
    func navigateToCreateCaseVc() {

        let vc = myStoryboard.instantiateViewController(withIdentifier: "CreateCaseVc") as! CreateCaseViewController
        
        vc.selectedCaseCategory = selectedCategory

        navigationController?.pushViewController(vc, animated: true)
    }
}
