//
//  CrackerTests.swift
//  CrackerTests
//
//  Created by Sydney Wu on 2020/12/31.
//

import XCTest
@testable import Cracker


class CrackerTests: XCTestCase {
    
    var stageVC: StageViewController?
    var stageRecords: [CrackerStageRecord] = []
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testWinnerTeam() throws {
        
        let stageRecord1 = CrackerStageRecord(stagePassed: 1, teamId: "TestTeamA", playerId: "Eric", triggerTime: FIRTimestamp(date: Date().addingTimeInterval(5)))
        let stageRecord2 = CrackerStageRecord(stagePassed: 1, teamId: "TestTeamB", playerId: "Sydney", triggerTime: FIRTimestamp(date: Date().addingTimeInterval(15)))
        let stageRecord3 = CrackerStageRecord(stagePassed: 2, teamId: "TestTeamA", playerId: "Max", triggerTime: FIRTimestamp(date: Date().addingTimeInterval(20)))
        let stageRecord4 = CrackerStageRecord(stagePassed: 2, teamId: "TestTeamA", playerId: "Max", triggerTime: FIRTimestamp(date: Date().addingTimeInterval(25)))
        
        stageRecords = [stageRecord1, stageRecord2, stageRecord3, stageRecord4]
        
        stageVC = StageViewController()
        
        stageVC?.sortStageRecords(stageRecords: stageRecords, stageCount: 2)
        
        XCTAssertEqual(stageVC?.winnerTeamId, "TestTeamA")
        XCTAssertNotEqual(stageVC?.winnerTeamId, "TestTeamB")
    }
    
    func testNoWinner() throws {
        
        let stageRecord1 = CrackerStageRecord(stagePassed: 1, teamId: "TestTeamA", playerId: "Eric", triggerTime: FIRTimestamp(date: Date().addingTimeInterval(5)))
        let stageRecord2 = CrackerStageRecord(stagePassed: 1, teamId: "TestTeamB", playerId: "Sydney", triggerTime: FIRTimestamp(date: Date().addingTimeInterval(15)))
        
        stageRecords = [stageRecord1, stageRecord2]
        
        stageVC = StageViewController()
        
        stageVC?.sortStageRecords(stageRecords: stageRecords, stageCount: 2)
        
        XCTAssertEqual(stageVC?.winnerTeamId, nil)
        XCTAssertNotEqual(stageVC?.winnerTeamId, "TestTeamB")
    }
    
    func testTie() throws {
        
        let stageRecord2 = CrackerStageRecord(stagePassed: 1, teamId: "TestTeamB", playerId: "Sydney", triggerTime: FIRTimestamp(date: Date().addingTimeInterval(5)))
        let stageRecord1 = CrackerStageRecord(stagePassed: 1, teamId: "TestTeamA", playerId: "Eric", triggerTime: FIRTimestamp(date: Date().addingTimeInterval(5)))
        
        stageRecords = [stageRecord1, stageRecord2]
        
        stageVC = StageViewController()
        
        stageVC?.sortStageRecords(stageRecords: stageRecords, stageCount: 1)
        
        XCTAssertEqual(stageVC?.winnerTeamId, "TestTeamB")
        XCTAssertNotEqual(stageVC?.winnerTeamId, "TestTeamA")
    }
}
