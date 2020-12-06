//
//  CaseIntro.swift
//  Cracker
//
//  Created by Sydney Wu on 2020/12/4.
//

import Foundation
import UIKit

class CaseIntroTBCell: UITableViewCell {
    
    @IBOutlet weak var caseIntroTitle: UILabel!
    @IBOutlet weak var caseIntroDetail: UILabel!
    
    func setupCaseLocationWith(cases: MockCase) {
        
        caseIntroTitle.text = "案發地點"
        caseIntroDetail.text = cases.location
    }
    
    func setupCaseTimeWith(cases: MockCase) {
        
        caseIntroTitle.text = "開放時間"
        caseIntroDetail.text = cases.startTime + "～" + cases.endTime
    }
    
    func setupCaseDurationWith(cases: MockCase) {
        
        caseIntroTitle.text = "破案時間"
        caseIntroDetail.text = cases.duration
    }
    
    func setupCaseHeadCountWith(cases: MockCase) {
        
        caseIntroTitle.text = "破案人數"
        caseIntroDetail.text = "\(cases.minHeadCount)" + "～" + "\(cases.maxHeadCount)" + "人"
    }
}
