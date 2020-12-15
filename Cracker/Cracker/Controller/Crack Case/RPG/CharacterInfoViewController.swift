//
//  CharacterInfoViewController.swift
//  Cracker
//
//  Created by Sydney Wu on 2020/12/15.
//

import UIKit

protocol CloseButtonDelegate: AnyObject {
    
    func closeBtnDidPress(_ didPress: Bool)
}

class CharacterInfoViewController: UIViewController {
    
    @IBOutlet weak var characterName: UILabel!
    @IBOutlet weak var characterInfo: UILabel!
    
    weak var delegate: CloseButtonDelegate?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
    }
    
    @IBAction func closeCharInfoPage(_ sender: Any) {
        
        delegate?.closeBtnDidPress(true)
    }
}

extension CharacterInfoViewController: PassCharContentDelegate {
    
    func getCharContentOf(charName: String, charInfo: String) {
        
        characterName.text = charName
        characterInfo.text = charInfo
    }
}
