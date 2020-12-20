//
//  User.swift
//  Cracker
//
//  Created by Sydney Wu on 2020/12/6.
//

import Foundation

struct CrackerUser: Codable {
    
    var id: String
    
    var name: String
    
    var rank: Int
    
    var image: String
    
    var treasuredCases: [CrackerCase]?
    
    var crackedCases: [CrackerCase]?
    
    init(id: String) {
        self.id = id
        self.name = "New Cracker"
        self.rank = 0
        self.image = ""
        self.treasuredCases = []
        self.crackedCases = []
    }
}
