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
    
    let stageContent: [StageContent]?
    
    let charContent: [CharContent]?
    
    let testContent: [TestContent]?
    
    let finalStageName: String?
    
    let finalPosition: CLLocationCoordinate2D?
    
    let open: String?
}

struct StageContent {
    
    let id: String
    
    let story: String
    
    let instruction: String
    
    let question: String
    
    let answer: String
    
    let hint: String
    
    let locationName: String
    
    let position: CLLocationCoordinate2D
}

struct CharContent {
    
    let id: String
    
    let name: String
    
    let location: String
    
    let info: String
    
    let triggers: [String]
    
    let talks: [String]
    
    let clues: [String]
    
    let position: CLLocationCoordinate2D
}

struct TestContent {
    
    let id: String
    
    let question: String
    
    let choices: [String]
    
    let answers: [String]
}

enum CaseCategory: String {
    
    case linear = "單線"
    
    case rpg = "RPG"
}

// MARK: - Mock Data For Linear Mode
let demoStage1 = StageContent(id: "1", story: "王子說他還沒睡飽，沒力氣學習，而且吃完香蕉以後肚子還是好餓...", instruction: "建議從吃的方面想答案", question: "要怎麼讓王子恢復力氣呢？", answer: "給力盒子", hint: "這題太簡單了不用提示", locationName: "灝美旅舍", position: CLLocationCoordinate2D(latitude: 25.041732, longitude: 121.548295))

let demoStage2 = StageContent(id: "2", story: "王子吃完東西已經恢復元氣了，現在他只要跟著他開發的App走就可以找到School了！", instruction: "請先解出王子開發的App名稱，再前往App Store下載該App", question: "王子開發的App叫什麼呢？", answer: "Yogogo", hint: "是六個字母的英文字詞", locationName: "給力盒子", position: CLLocationCoordinate2D(latitude: 25.041990, longitude: 121.563394))

let demoLinearCase = MockCase(name: "王子上學去", creator: "Princekili", image: UIImage(named: "Little Prince")!, score: 1, category: CaseCategory.linear, location: "捷運忠孝敦化站周邊", startTime: "10:30", endTime: "18:00", duration: "2小時", maxHeadCount: 10, minHeadCount: 1, description: "王子今天又遲到了，你們能幫他找到去School的路嗎？請先到王子寄宿的灝美旅舍叫醒他吧！", stageContent: [demoStage1, demoStage2], charContent: nil, testContent: nil, finalStageName: "AppWorks School", finalPosition: CLLocationCoordinate2D(latitude: 25.042404, longitude: 121.564885), open: nil)

// MARK: - Mock Data For RPG Mode
let demoChar1 = CharContent(id: "1", name: "竈門炭治郎", location: "雲取山", info: "竈門家長子，禰豆子的大哥，是有著一頭深紅髮與紅色眼睛的「赫灼之子」，遺傳母親那有如石頭般堅硬的額頭，左額上有著小時候為保護弟弟，而被滾燙的水壺燒傷的大片傷痕，耳上掛著日輪花紙耳飾。為平凡農家子弟的長兄，父親早逝，因此靠著賣炭維持家裡的生計。", triggers: ["要怎麼從夢裡醒來"], talks: ["全集中水之呼吸", "我要繼續出招才行"], clues: ["只要在夢裡xxx就行了"], position: CLLocationCoordinate2D(latitude: 25.040611, longitude: 121.561328))

let demoChar2 = CharContent(id: "2", name: "嘴平伊之助", location: "大岳山", info: "與炭治郎同期的鬼殺隊劍士，頭戴灰色的山豬頭面具，上半身赤裸且身材魁梧的少年，面具下卻是美少女般的臉蛋。不喜歡穿衣服，除療養外多半都是赤裸著上半身。初期性格粗暴殘忍，為達成目的可以不顧周遭人的感受，通常是有話直說直接開打型。", triggers: ["鬼的喉嚨在哪裡", "炎柱吃的便當叫什麼"], talks: ["豬突猛進"], clues: ["漆之型 空間視覺...在xxx！！", "牛鍋便當"], position: CLLocationCoordinate2D(latitude: 25.037683, longitude: 121.564603))

let demoTest1 = TestContent(id: "1", question: "炎柱交代炭治郎的任務是什麼？", choices: ["幫他吃便當", "找主公", "練好全集中呼吸"], answers: ["找主公"])

let demoTest2 = TestContent(id: "2", question: "善逸在列車裡面做了什麼？", choices: ["哭", "使用雷之呼吸"], answers: ["哭", "使用雷之呼吸"])

let demoRpgCase = MockCase(name: "無限列車滅鬼案", creator: "吾峠呼世晴", image: UIImage(named: "Infinite Train")!, score: 5, category: CaseCategory.rpg, location: "無限列車", startTime: "9:00", endTime: "18:00", duration: "約5小時", maxHeadCount: 4, minHeadCount: 1, description: "結束蝴蝶屋的訓練後，竈門炭治郎等一行人到達下一個任務地點「無限列車」，並與鬼殺隊炎柱・煉獄杏壽郎會合，一同調查列車上的四十多人失蹤事件，而下弦之壹・魘夢也潛伏在列車之中。身為鬼殺隊成員的你們，請協助炭治郎完成這次的任務。", stageContent: nil, charContent: [demoChar1, demoChar2], testContent: [demoTest1, demoTest2], finalStageName: nil, finalPosition: nil, open: "大正時代，竈門炭治郎繼承亡父留下的炭業工作，支撐一家七口，在山上過著樸實的生活。某日他做完生意返家後發現全家遭鬼王鬼舞辻無慘屠殺，而妹妹禰豆子變成了鬼。鬼殺隊富岡義勇見狀後本欲斬殺禰豆子，但他在見識到兄妹倆的親情後，推薦炭治郎拜鱗瀧左近次為師。炭治郎經過兩年訓練，學會對抗鬼的呼吸法與劍術，通過考驗加入鬼殺隊。炭治郎在接踵而來的任務中擊敗多個鬼，並首次接觸鬼的首領，也是殺害自己全家的元凶──活了千年的無慘。炭治郎認識與無慘對立的鬼珠世，與她建立合作關係。在結識同伴我妻善逸和嘴平伊之助後，他們前去蜘蛛山支援與下弦之伍的對戰。炭治郎在苦戰之際使出祖傳的呼吸法「火之神神樂」，以及禰豆子覺醒的血鬼術一度扭轉頹勢，最終在義勇助陣下取勝。")

// MARK: - Other Mock Case
let case1 = MockCase(name: "德利小鎮失蹤案", creator: "Sydney", image: UIImage(named: "It")!, score: 3, category: CaseCategory.linear, location: "德利小鎮", startTime: "18:00", endTime: "4:00", duration: "約8小時", maxHeadCount: 10, minHeadCount: 5, description: "玩家將扮演27 年後再度回到德瑞鎮的魯蛇俱樂部成員們，與來自童年的惡夢——恐怖小丑「潘尼懷斯」展開一場最終對決。", stageContent: nil, charContent: nil, testContent: nil, finalStageName: nil, finalPosition: nil, open: nil)

let case2 = MockCase(name: "史丹利飯店閃靈", creator: "Stephen King", image: UIImage(named: "Shining")!, score: 4, category: CaseCategory.rpg, location: "史丹利飯店", startTime: "24:00", endTime: "5:00", duration: "3小時左右", maxHeadCount: 4, minHeadCount: 2, description: "傑克·托倫斯是一名作家，為了擺脫工作上的失意，接受了一份在冬天維護科羅拉多州一家奢華的山間飯店的工作。傑克年幼的兒子擁有通靈能力，能夠看到過去和未來的東西，如棲息在酒店的鬼魂。到酒店安頓好後不久，這家人就被暴風雪困住了，傑克逐漸受到一個超自然的存在的影響；他陷入瘋狂並企圖謀殺他的妻子和兒子。", stageContent: nil, charContent: nil, testContent: nil, finalStageName: nil, finalPosition: nil, open: nil)

let case3 = MockCase(name: "追殺比爾", creator: "Quentin Tarantino", image: UIImage(named: "Kill Bill")!, score: 5, category: CaseCategory.rpg, location: "Tokyo", startTime: "6:00", endTime: "18:00", duration: "10小時", maxHeadCount: 10, minHeadCount: 5, description: "A woman in a wedding dress, the Bride, lies wounded in a chapel in El Paso, Texas, having been attacked by the Deadly Viper Assassination Squad.", stageContent: nil, charContent: nil, testContent: nil, finalStageName: nil, finalPosition: nil, open: nil)

let case4 = MockCase(name: "Joker", creator: "Sydney", image: UIImage(named: "Joker")!, score: 5, category: CaseCategory.linear, location: "NYC", startTime: "22:00", endTime: "24:00", duration: "40分鐘", maxHeadCount: 4, minHeadCount: 1, description: "1981年，高譚市正值垃圾成災、充滿失業和犯罪的經濟蕭條時期，貧富差距巨大導致許多窮人流落街頭、失去基本權利。身為社會局外人的亞瑟·佛萊克立志成為一位單口喜劇演員，做起派對小丑來供養他的年邁母親潘妮。亞瑟本身患有一種罕見精神疾病，導致他在不合時宜的時候會放聲大笑，只能接受社福機構人員的治療以獲取藥物。", stageContent: nil, charContent: nil, testContent: nil, finalStageName: nil, finalPosition: nil, open: nil)

let popularCases = [case1, demoLinearCase]
let classicCases = [case2, demoRpgCase]

let crackedCases = [case1, case2]
let createdCases = [case1, case4]
let treasuredCases = [case2, case3, case4]


