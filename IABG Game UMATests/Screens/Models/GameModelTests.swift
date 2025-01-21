//
//  GameModelTests.swift
//  IABG Game UMA
//
//  Created by Diego Sánchez on 18/1/25.
//

import XCTest
@testable import IABG_Game_UMA

class GameModelTests: XCTestCase {
    
    func testEndgameModel() {
        let model: EndGameModel = EndGameModel(index: 2,
                                               realResult: 12,
                                               totalElements: 23,
                                               posibleResult: 12)
        
        XCTAssertNotEqual(model.index, 6)
        XCTAssertEqual(model.realResult, 12)
        XCTAssertNotEqual(model.totalElements, 6)
        XCTAssertEqual(model.posibleResult, 12)
    }
    
    func testsEndGameRequestModel() {
        let model: EndGameRequestModel = EndGameRequestModel(userID: "prueba",
                                                             level: 2,
                                                             perPred: 12,
                                                             perAgil: 34,
                                                             globalPer: 15,
                                                             totSuccess: 50,
                                                             totPredict: 55)
        XCTAssertTrue(model.userID == "prueba")
        XCTAssertNotEqual(model.level, 6)
        XCTAssertFalse(model.userID.isEmpty)
        XCTAssertEqual(model.perPred, 12)
        XCTAssertNotEqual(model.perAgil, 6)
        XCTAssertEqual(model.globalPer, 15)
        XCTAssertEqual(model.totSuccess, 50)
        XCTAssertNotEqual(model.totPredict, 12)
    }
    
    
}
