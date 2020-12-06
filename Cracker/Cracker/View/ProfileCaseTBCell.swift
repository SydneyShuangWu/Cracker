//
//  ProfileCaseTBCell.swift
//  Cracker
//
//  Created by Sydney Wu on 2020/12/7.
//

import Foundation
import UIKit

class ProfileCaseTBCell: UITableViewCell {
    
    @IBOutlet weak var caseImage: UIImageView!
    @IBOutlet weak var caseName: UILabel!
    @IBOutlet weak var caseCreator: UILabel!
    @IBOutlet weak var caseScore: UILabel!
    @IBOutlet weak var binBtn: UIButton!
    
    func setupCellWith(cases: MockCase) {
        
        caseImage.image = cases.image
        caseImage.layer.cornerRadius = caseImage.frame.size.width / 2
        caseImage.clipsToBounds = true
        caseName.text = cases.name
        caseCreator.text = cases.creator
        caseScore.text = String(cases.score)
    }
    
    func enableBinBtn() {
        
        binBtn.isUserInteractionEnabled = true
        binBtn.isHidden = false
    }
    
    func disableBinBtn() {
        
        binBtn.isUserInteractionEnabled = false
        binBtn.isHidden = true
    }
}
