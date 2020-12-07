//
//  RPGBoardViewController.swift
//  Cracker
//
//  Created by Sydney Wu on 2020/12/7.
//

import UIKit

class RPGBoardViewController: UIViewController {

    override func viewDidLoad() {
        
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {

        super.viewWillAppear(animated)

        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

}
