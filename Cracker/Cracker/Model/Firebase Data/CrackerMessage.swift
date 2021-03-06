//
//  CrackerMessag.swift
//  Cracker
//
//  Created by Sydney Wu on 2020/12/18.
//

import Foundation

struct CrackerMessage: Codable {
    
    var userSender: String
    
    var characterSender: String
    
    var content: String
    
    var sendTime: FIRTimestamp
}
