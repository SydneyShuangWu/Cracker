//
//  ViewController.swift
//  Cracker
//
//  Created by Sydney Wu on 2020/11/27.
//

import Foundation
import UIKit

class LobbyViewController: UIViewController {
    
    @IBOutlet weak var crackCaseBtn: UIButton!
    
    @IBOutlet weak var createCaseBtn: UIButton!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setupButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    func setupButton() {
        
        crackCaseBtn.setupCornerRadius()
        
        createCaseBtn.setupCornerRadius()
        
        createCaseBtn.setupBorder()
    }
    
}

