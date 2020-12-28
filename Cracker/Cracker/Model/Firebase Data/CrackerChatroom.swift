//
//  CrackerChatroom.swift
//  Cracker
//
//  Created by Sydney Wu on 2020/12/18.
//

import Foundation

struct CrackerChatroom: Codable {
    
    var id: String
    
    var name: String
    
    var messages: [CrackerMessage]
    
    var teams: [String]
}
