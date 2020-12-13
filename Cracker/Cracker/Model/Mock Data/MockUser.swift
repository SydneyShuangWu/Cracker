//
//  MockUser.swift
//  Cracker
//
//  Created by Sydney Wu on 2020/12/6.
//

import Foundation
import UIKit

struct MockUser {
    
    let id: String
    
    let name: String
    
    let rank: Int
    
    let image: UIImage
    
    let friendList: [MockUser]?
    
    let pendingList: [MockUser]?
    
    let treasuredCases: [MockCase]?
    
    let crackedCases: [MockCase]?
    
    let createdCases: [MockCase]?
}

let sydney = MockUser(id: "0120bvgiej49", name: "Sydney", rank: 5, image: UIImage(named: "Sydney")!, friendList: friendList, pendingList: nil, treasuredCases: treasuredCases, crackedCases: crackedCases, createdCases: createdCases)

let sugar = MockUser(id: "1234fjkejgej", name: "Sugar", rank: 10, image: UIImage(named: "Sugar")!, friendList: nil, pendingList: nil, treasuredCases: nil, crackedCases: nil, createdCases: nil)

let friendList = [sugar]
