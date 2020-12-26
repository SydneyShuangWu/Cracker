//
//  SearchCaseTVCell.swift
//  Cracker
//
//  Created by Sydney Wu on 2020/12/4.
//

import Foundation
import UIKit
import FirebaseAuth

class SearchCaseTBCell: UITableViewCell {
    
    @IBOutlet weak var caseImage: UIImageView!
    @IBOutlet weak var caseName: UILabel!
    @IBOutlet weak var caseScore: UILabel!
    
    func setupCellWith(cases: CrackerCase) {
        
        caseImage.loadImage(cases.image)
        caseImage.layer.cornerRadius = caseImage.frame.size.width / 2
        caseImage.clipsToBounds = true
        caseName.text = cases.name
        
        guard let score = cases.score else { return }
        caseScore.text = String(score)
    }
}
