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
    
    var gameDidStart: Bool = false
}
