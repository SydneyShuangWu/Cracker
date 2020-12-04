//
//  CaseImage.swift
//  Cracker
//
//  Created by Sydney Wu on 2020/12/4.
//

import Foundation
import UIKit

class CaseImageTBCell: UITableViewCell {
    
    @IBOutlet weak var caseImage: UIImageView!
    @IBOutlet weak var caseCategory: UILabel!
    
    func setupCaseImageWith(cases: CaseDetail) {
        
        caseImage.image = cases.image
        caseCategory.text = "# " + cases.category.rawValue
        caseCategory.setupCornerRadius()
    }
}


