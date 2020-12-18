//
//  User.swift
//  Cracker
//
//  Created by Sydney Wu on 2020/12/6.
//

import Foundation

struct CrackerUser: Codable {
    
    let id: String
    
    let name: String
    
    let rank: Int
    
    let image: String
    
    let friendList: [CrackerUser]?
    
    let pendingList: [CrackerUser]?
    
    let treasuredCases: [CrackerCase]?
    
    let crackedCases: [CrackerCase]?
    
    init(id: String) {
        self.id = id
        self.name = ""
        self.rank = 0
        self.image = ""
        self.friendList = []
        self.pendingList = []
        self.treasuredCases = []
        self.crackedCases = []
    }
    
    
}

//let sydney = User(id: "0120bvgiej49", name: "Sydney", rank: 5, image: UIImage(named: "Sydney")!, friendList: friendList, pendingList: nil, treasuredCases: treasuredCases, crackedCases: crackedCases, createdCases: createdCases)
//
//let sugar = User(id: "1234fjkejgej", name: "Sugar", rank: 10, image: UIImage(named: "Sugar")!, friendList: nil, pendingList: nil, treasuredCases: nil, crackedCases: nil, createdCases: nil)
//
//let friendList = [sugar]
