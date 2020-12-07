//
//  MockCase.swift
//  Cracker
//
//  Created by Sydney Wu on 2020/12/3.
//

import Foundation
import UIKit
import MapKit

struct MockCase {
    
    let name: String
    
    let creator: String
    
    let image: UIImage
    
    let score: Int
    
    let category: CaseCategory
    
    let location: String
    
    let startTime: String
    
    let endTime: String
    
    let duration: String
    
    let maxHeadCount: Int
    
    let minHeadCount: Int
    
    let description: String
    
    let opening: String?
    
    let charContent: [CharContent]?
}

struct CharContent {
    
    let id: String
    
    let name: String
    
    let location: String
    
    let info: String
    
    let triggers: [String]
    
    let talks: [String]
    
    let hints: [String]
    
    let position: CLLocationCoordinate2D
}

enum CaseCategory: String {
    
    case linear = "單線"
    
    case rpg = "RPG"
}

// MARK: - Mock Data
let infiniteTrainCharContent1 = CharContent(id: "1", name: "竈門炭治郎", location: "蟲柱家", info: "竈門家長子，禰豆子的大哥，造型為制服上披著市松圖案的羽織，有著一頭深紅髮與紅色眼睛的「赫灼之子」，遺傳母親那有如石頭般堅硬的額頭，左額上有著小時候為保護弟弟，而被滾燙的水壺燒傷的大片傷痕，耳上掛著日輪花紙耳飾。為平凡農家子弟的長兄，父親早逝，因此靠著賣炭維持家裡的生計。", triggers: ["鬼的喉嚨藏在哪裡"], talks: ["全集中水之呼吸", "我要繼續出招才行"], hints: ["你去問伊之助，他應該知道"], position: CLLocationCoordinate2D(latitude: 25.047337, longitude: 121.564085))

let infiniteTrainCharContent2 = CharContent(id: "2", name: "善逸", location: "爺爺家", info: "性格十分膽小，經常認為自己馬上就要死了，為了不要在單身狀態下死去，不斷糾纏着任何女孩子要對方跟他結婚，但另一方面卻心地善良，會為朋友和女孩子挺身而出，會為守護別人珍視的東西而勇往直前。", triggers: ["禰豆子在哪裡"], talks: ["鬼好可怕", "我快死了", "禰豆子嘿嘿"], hints: ["在箱子裡面，但我只知道箱子的密碼在蜘蛛山下，蜘蛛山在哪我不知道，你可能要問麻雀。"], position: CLLocationCoordinate2D(latitude: 25.037876, longitude: 121.568167))

let case1 = MockCase(name: "無限列車滅鬼案", creator: "Sydney", image: UIImage(named: "Infinite Train")!, score: 5, category: CaseCategory.linear, location: "無限列車", startTime: "9:00", endTime: "18:00", duration: "約5小時", maxHeadCount: 4, minHeadCount: 1, description: "結束蝴蝶屋的訓練後，竈門炭治郎等一行人到達下一個任務地點「無限列車」，並與鬼殺隊炎柱・煉獄杏壽郎會合，一同調查列車上的四十多人失蹤事件，而下弦之壹・魘夢也潛伏在列車之中。", opening: "烏鴉要我們在東京車站集合。", charContent: [infiniteTrainCharContent1, infiniteTrainCharContent2])

let case2 = MockCase(name: "德利小鎮失蹤案", creator: "It", image: UIImage(named: "It")!, score: 3, category: CaseCategory.linear, location: "德利小鎮", startTime: "18:00", endTime: "4:00", duration: "約8小時", maxHeadCount: 10, minHeadCount: 5, description: "玩家將扮演27 年後再度回到德瑞鎮的魯蛇俱樂部成員們，與來自童年的惡夢——恐怖小丑「潘尼懷斯」展開一場最終對決。", opening: nil, charContent: nil)

let case3 = MockCase(name: "史丹利飯店閃靈", creator: "Stephen King", image: UIImage(named: "Shining")!, score: 4, category: CaseCategory.rpg, location: "史丹利飯店", startTime: "24:00", endTime: "5:00", duration: "3小時左右", maxHeadCount: 4, minHeadCount: 2, description: "傑克·托倫斯是一名作家，為了擺脫工作上的失意，接受了一份在冬天維護科羅拉多州一家奢華的山間飯店的工作。傑克年幼的兒子擁有通靈能力，能夠看到過去和未來的東西，如棲息在酒店的鬼魂。到酒店安頓好後不久，這家人就被暴風雪困住了，傑克逐漸受到一個超自然的存在的影響；他陷入瘋狂並企圖謀殺他的妻子和兒子。", opening: nil, charContent: nil)

let case4 = MockCase(name: "追殺比爾", creator: "Quentin Tarantino", image: UIImage(named: "Kill Bill")!, score: 5, category: CaseCategory.rpg, location: "Tokyo", startTime: "6:00", endTime: "18:00", duration: "10小時", maxHeadCount: 10, minHeadCount: 5, description: "A woman in a wedding dress, the Bride, lies wounded in a chapel in El Paso, Texas, having been attacked by the Deadly Viper Assassination Squad.", opening: nil, charContent: nil)

let case5 = MockCase(name: "Joker", creator: "Sydney", image: UIImage(named: "Joker")!, score: 5, category: CaseCategory.linear, location: "NYC", startTime: "22:00", endTime: "24:00", duration: "40分鐘", maxHeadCount: 4, minHeadCount: 1, description: "1981年，高譚市正值垃圾成災、充滿失業和犯罪的經濟蕭條時期，貧富差距巨大導致許多窮人流落街頭、失去基本權利。身為社會局外人的亞瑟·佛萊克立志成為一位單口喜劇演員，做起派對小丑來供養他的年邁母親潘妮。亞瑟本身患有一種罕見精神疾病，導致他在不合時宜的時候會放聲大笑，只能接受社福機構人員的治療以獲取藥物。", opening: nil, charContent: nil)

let popularCases = [case1, case2]
let classicCases = [case3]

let crackedCases = [case2, case3]
let createdCases = [case1, case5]
let treasuredCases = [case4, case2, case3]


