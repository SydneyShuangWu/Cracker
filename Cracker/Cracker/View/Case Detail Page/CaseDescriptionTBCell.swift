//
//  CaseDescription.swift
//  Cracker
//
//  Created by Sydney Wu on 2020/12/4.
//

import Foundation
import UIKit

class CaseDescriptionTBCell: UITableViewCell {
    
    @IBOutlet weak var caseDescriptionTitle: UILabel!
    @IBOutlet weak var caseDescriptionDetail: UILabel!
    
    func setupCaseDescriptionWith(cases: CaseDetail) {
        
        caseDescriptionTitle.text = "案件說明"
        caseDescriptionDetail.text = cases.description
    }
}
