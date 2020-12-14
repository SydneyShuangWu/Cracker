//
//  RPGBoardViewController.swift
//  Cracker
//
//  Created by Sydney Wu on 2020/12/7.
//

import UIKit

class RPGViewController: UIViewController {
    
    @IBOutlet weak var openLabel: UILabel!
    @IBOutlet weak var checkAnswerBtn: UIButton!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {

        super.viewWillAppear(animated)

        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    func setupUI() {
        
        checkAnswerBtn.layer.cornerRadius = checkAnswerBtn.frame.width / 2
        
        openLabel.text = demoRpgCase.open
    }


}
