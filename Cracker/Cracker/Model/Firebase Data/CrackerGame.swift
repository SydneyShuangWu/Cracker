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
    
    var id: String
    
    var crackerCase: CrackerCase
    
    var gameMode: String
    
    var crackerChatrooms: [String]
    
    var createdTime: FIRTimestamp
    
    var startTime: FIRTimestamp
    
    var endTime: FIRTimestamp
    
    var players: [CrackerPlayer]
    
    var teams: [CrackerTeam]?
    
    var stageRecords: [CrackerStageRecord]
    
    var finalScore: Int
    
    var finalRank: Int
}

// Transfer timestamp to date
// var date = FIRTimestamp().dateValue()
