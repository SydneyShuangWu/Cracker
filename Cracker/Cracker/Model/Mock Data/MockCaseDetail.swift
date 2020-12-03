//
//  MockCaseIntro.swift
//  Cracker
//
//  Created by Sydney Wu on 2020/12/3.
//

import Foundation
import UIKit

struct CaseDetail {
    
    let name: String
    
    let creator: String
    
    let image: UIImage
    
    let score: Double
    
    let category: Category
    
    let location: String
    
    let startTime: String
    
    let endTime: String
    
    let duration: String
    
    let maxHeadCount: Int
    
    let minHeadCount: Int
    
    let description: String
}

enum Category: String {
    
    case linear = "單線"
    
    case rpg = "RPG"
}

// MARK: - Mock Data
let case1 = CaseDetail(name: "無限列車滅鬼案", creator: "吾峠呼世晴", image: UIImage(named: "Infinite Train")!, score: 5, category: Category.linear, location: "無線列車", startTime: "9:00", endTime: "18:00", duration: "約5小時", maxHeadCount: 1, minHeadCount: 4, description: "結束蝴蝶屋的訓練後，竈門炭治郎等一行人到達下一個任務地點「無限列車」，並與鬼殺隊炎柱・煉獄杏壽郎會合，一同調查列車上的四十多人失蹤事件，而下弦之壹・魘夢也潛伏在列車之中。")

let case2 = CaseDetail(name: "德利小鎮孩童失蹤事件", creator: "It", image: UIImage(named: "It")!, score: 3, category: Category.linear, location: "德利小鎮", startTime: "18:00", endTime: "4:00", duration: "約8小時", maxHeadCount: 5, minHeadCount: 10, description: "玩家將扮演27 年後再度回到德瑞鎮的魯蛇俱樂部成員們，與來自童年的惡夢——恐怖小丑「潘尼懷斯」展開一場最終對決。")

let case3 = CaseDetail(name: "史丹利飯店閃靈", creator: "Stephen King", image: UIImage(named: "Shining")!, score: 4.5, category: Category.rpg, location: "史丹利飯店", startTime: "24:00", endTime: "5:00", duration: "3小時左右", maxHeadCount: 2, minHeadCount: 4, description: "傑克·托倫斯是一名作家，為了擺脫工作上的失意，接受了一份在冬天維護科羅拉多州一家奢華的山間飯店的工作。傑克年幼的兒子擁有通靈能力，能夠看到過去和未來的東西，如棲息在酒店的鬼魂。到酒店安頓好後不久，這家人就被暴風雪困住了，傑克逐漸受到一個超自然的存在的影響；他陷入瘋狂並企圖謀殺他的妻子和兒子。")

let popularCases = [case1, case2]
let classicCases = [case3]
