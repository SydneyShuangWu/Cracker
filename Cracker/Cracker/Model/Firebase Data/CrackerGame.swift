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
    
    var crackerCase: CrackerCase = CrackerCase()
    
    var gameMode: String = ""
    
    var crackerChatrooms: [String] = []
    
    var startTime: FIRTimestamp = FIRTimestamp()
    
    var endTime: FIRTimestamp = FIRTimestamp()
    
    var players: [CrackerPlayer] = []
    
    var teams: [CrackerTeam]? = []
    
    var stageRecords: [CrackerStageRecord] = []
    
    var finalScore: Int = 0
    
    var finalRank: Int = 0
}

// Transfer timestamp to date
// var date = FIRTimestamp().dateValue()
