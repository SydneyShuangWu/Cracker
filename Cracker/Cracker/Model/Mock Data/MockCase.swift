//
//  MockCase.swift
//  Cracker
//
//  Created by Sydney Wu on 2020/12/3.
//

import Foundation
import UIKit

struct MockCase {
    
    let name: String
    
    let creator: String
    
    let image: UIImage
    
    let score: Int
    
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
let case1 = MockCase(name: "無限列車滅鬼案", creator: "Sydney", image: UIImage(named: "Infinite Train")!, score: 5, category: Category.linear, location: "無線列車", startTime: "9:00", endTime: "18:00", duration: "約5小時", maxHeadCount: 4, minHeadCount: 1, description: "結束蝴蝶屋的訓練後，竈門炭治郎等一行人到達下一個任務地點「無限列車」，並與鬼殺隊炎柱・煉獄杏壽郎會合，一同調查列車上的四十多人失蹤事件，而下弦之壹・魘夢也潛伏在列車之中。")

let case2 = MockCase(name: "德利小鎮失蹤案", creator: "It", image: UIImage(named: "It")!, score: 3, category: Category.linear, location: "德利小鎮", startTime: "18:00", endTime: "4:00", duration: "約8小時", maxHeadCount: 10, minHeadCount: 5, description: "玩家將扮演27 年後再度回到德瑞鎮的魯蛇俱樂部成員們，與來自童年的惡夢——恐怖小丑「潘尼懷斯」展開一場最終對決。")

let case3 = MockCase(name: "史丹利飯店閃靈", creator: "Stephen King", image: UIImage(named: "Shining")!, score: 4, category: Category.rpg, location: "史丹利飯店", startTime: "24:00", endTime: "5:00", duration: "3小時左右", maxHeadCount: 4, minHeadCount: 2, description: "傑克·托倫斯是一名作家，為了擺脫工作上的失意，接受了一份在冬天維護科羅拉多州一家奢華的山間飯店的工作。傑克年幼的兒子擁有通靈能力，能夠看到過去和未來的東西，如棲息在酒店的鬼魂。到酒店安頓好後不久，這家人就被暴風雪困住了，傑克逐漸受到一個超自然的存在的影響；他陷入瘋狂並企圖謀殺他的妻子和兒子。")

let case4 = MockCase(name: "追殺比爾", creator: "Quentin Tarantino", image: UIImage(named: "Kill Bill")!, score: 5, category: Category.rpg, location: "Tokyo", startTime: "6:00", endTime: "18:00", duration: "10小時", maxHeadCount: 10, minHeadCount: 5, description: "A woman in a wedding dress, the Bride, lies wounded in a chapel in El Paso, Texas, having been attacked by the Deadly Viper Assassination Squad.")

let case5 = MockCase(name: "Joker", creator: "Sydney", image: UIImage(named: "Joker")!, score: 5, category: Category.linear, location: "NYC", startTime: "22:00", endTime: "24:00", duration: "40分鐘", maxHeadCount: 4, minHeadCount: 1, description: "1981年，高譚市正值垃圾成災、充滿失業和犯罪的經濟蕭條時期，貧富差距巨大導致許多窮人流落街頭、失去基本權利。身為社會局外人的亞瑟·佛萊克立志成為一位單口喜劇演員，做起派對小丑來供養他的年邁母親潘妮。亞瑟本身患有一種罕見精神疾病，導致他在不合時宜的時候會放聲大笑，只能接受社福機構人員的治療以獲取藥物。一次工作時，亞瑟被一群小孩偷走招牌，被他們引入小巷裡暴打，他的同事藍道送他一把自保用的左輪手槍。回家時，亞瑟開始對他的鄰居蘇菲·杜蒙感興趣，邀請她前來觀看自己的單口喜劇表演，隨即順利跟她開始交往。")

let popularCases = [case1, case2]
let classicCases = [case3]

let crackedCases = [case2, case3]
let createdCases = [case1, case5]
let treasuredCases = [case4, case2, case3]


