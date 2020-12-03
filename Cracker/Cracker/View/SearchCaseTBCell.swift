//
//  SearchCaseTVCell.swift
//  Cracker
//
//  Created by Sydney Wu on 2020/12/4.
//

import Foundation
import UIKit

class SearchCaseTBCell: UITableViewCell {
    
    @IBOutlet weak var caseImage: UIImageView!
    @IBOutlet weak var caseName: UILabel!
    @IBOutlet weak var caseCreator: UILabel!
    @IBOutlet weak var caseScore: UILabel!
    
    func setupCellWith(cases: CaseDetail) {
        
        caseImage.image = cases.image
        caseImage.layer.cornerRadius = caseImage.frame.size.width / 2
        caseImage.clipsToBounds = true
        caseName.text = cases.name
        caseCreator.text = cases.creator
        caseScore.text = String(cases.score)
    }
}
