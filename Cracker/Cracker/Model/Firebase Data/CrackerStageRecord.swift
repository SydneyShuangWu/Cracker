//
//  CrackerStageRecords.swift
//  Cracker
//
//  Created by Sydney Wu on 2020/12/18.
//

import Foundation

struct CrackerStageRecord: Codable {
    
    var stagePassed: Int = 0
    
    var teamId: String = ""
    
    var playerId: String = ""
    
    var triggerTime: FIRTimestamp = FIRTimestamp()
}
