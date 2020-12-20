//
//  JoinTeamViewController.swift
//  Cracker
//
//  Created by Sydney Wu on 2020/12/19.
//

import UIKit

class JoinTeamViewController: UIViewController {
    
    @IBOutlet weak var teamIdTF: UITextField!
    
    var closeJoinTeam: ((Bool) -> Void)?

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        teamIdTF.setupCornerRadius()
        teamIdTF.setupTextFieldBorder()
    }
    
    @IBAction func closeJoinTeamPage(_ sender: Any) {
        
        closeJoinTeam?(true)
    }
}
