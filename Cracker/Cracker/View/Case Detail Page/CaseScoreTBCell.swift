//
//  CaseScore.swift
//  Cracker
//
//  Created by Sydney Wu on 2020/12/4.
//

import Foundation
import UIKit

class CaseScoreTBCell: UITableViewCell {
    
    @IBOutlet weak var caseScore: UILabel!
    
    func setupCaseScoreWith(cases: CaseDetail) {
        
        caseScore.text = "案件評分"
        
        for index in 0 ..< cases.score {
            
            let starImageView = UIImageView(image: UIImage(named: "Star"))
            
            starImageView.frame = CGRect(x: 120 + 40 * index, y: 8, width: 30, height: 30)
            
            contentView.addSubview(starImageView)
        }
    }
}
