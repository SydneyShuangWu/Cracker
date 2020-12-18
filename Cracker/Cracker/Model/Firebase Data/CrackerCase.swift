//
//  CrackerCase.swift
//  Cracker
//
//  Created by Sydney Wu on 2020/12/17.
//

import Foundation

enum Category: String {
    
    case linear = "Linear"
    
    case rpg = "RPG"
}

struct CrackerCase: Codable {
    
    var id: String = ""
    
    var creator: CrackerUser = CrackerUser(id: "")
    
    var name: String = ""
    
    var image: String = ""
    
    var category: String = ""
    
    var location: String = ""
    
    var startTime: String = ""
    
    var endTime: String = ""
    
    var duration: String = ""
    
    var maxHeadCount: Int = 0
    
    var minHeadCount: Int = 0
    
    var introduction: String = ""
    
    var contentCount: Int = 0
    
    var stages: [CrackerStage]? = []
    
    var finalStageName: String? = ""
    
    var finalStageLongitude: Double? = 0
    
    var finalStageLatitude: Double? = 0
    
    var script: String? = ""
    
    var characters: [CrackerCharacter]? = []
    
    var tests: [CrackerTest]? = []
    
    var score: Int? = 0
    
    var comments: [String]? = []
}

struct CrackerStage: Codable {
    
    var story: String = ""
    
    var instruction: String = ""
    
    var question: String = ""
    
    var answer: String = ""
    
    var hint: String = ""
    
    var locationName: String = ""

    var longitude: Double = 0
    
    var latitude: Double = 0
}

struct CrackerCharacter: Codable {
    
    var id: String
    
    var name: String
    
    var locationName: String
    
    var brief: String
    
    var image: String
    
    var longitude: Double
    
    var latitude: Double
    
    var triggers: CrackerTrigger
    
    var talks: [String]
    
    var clues: [String]
}

struct CrackerTrigger: Codable {
    
    var id: Int
    
    var keywords: [String]
}

struct CrackerTest: Codable {
    
    var id: Int
    
    var question: String
    
    var choices: [String]
    
    var answers: [String]
}
