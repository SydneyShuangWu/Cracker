//
//  CrackerPlayer.swift
//  Cracker
//
//  Created by Sydney Wu on 2020/12/18.
//

import Foundation

struct CrackerPlayer: Codable {
    
    var id: String = ""
    
    var name: String = ""
    
    var image: String = ""
    
    var teamId: String = ""
    
    var longitude: Double? = 0
    
    var latitude: Double? = 0
    
    var startTime: FIRTimestamp = FIRTimestamp()
    
    var endTime: FIRTimestamp = FIRTimestamp()
    
    var isWinner: Bool = false
}
