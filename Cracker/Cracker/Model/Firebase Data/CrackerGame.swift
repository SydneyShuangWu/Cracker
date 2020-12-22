//
//  CrackerGame.swift
//  Cracker
//
//  Created by Sydney Wu on 2020/12/18.
//

import Foundation

enum Mode: String {
    
    case challenge = "Challenge"
    
    case battle = "Battle"
}

struct CrackerGame: Codable {
    
    var id: String = ""
    
    var gameMode: String = ""
    
    var teams: [String] = []
    
    var chatrooms: [String] = []
    
    var startTime: FIRTimestamp = FIRTimestamp()
    
    var endTime: FIRTimestamp = FIRTimestamp()
    
    var stageRecords: [CrackerStageRecord] = []
    
    var finalScore: Int = 0
    
    var finalRank: Int = 0
    
    var gameDidStart: Bool = false
}

// Transfer timestamp to date
// var date = FIRTimestamp().dateValue()
