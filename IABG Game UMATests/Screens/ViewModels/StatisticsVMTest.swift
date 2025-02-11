//
//  StatisticsVMTest.swift
//  IABG Game UMA
//
//  Created by Diego Sánchez on 5/2/25.
//

import XCTest
import SwiftUI
@testable import IABG_Game_UMA

class StatisticsVMTest: XCTestCase {
    
    var viewModel: StatisticsVM!
    
    override func setUp() {
        super.setUp()
        
        let statisticsModel = getStatisticaModelMock()
        viewModel = StatisticsVM(staticticsModel: statisticsModel)
        
    }
    
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
    func testLevelText() {
        
        let statisticsModel = getStatisticaModelMock()
        
        XCTAssertNotNil(viewModel.levelText)
        
        viewModel.staticticsModel =  StatisticsModel(level: .easy,
                                                      totalAttemps: statisticsModel.totalAttemps,
                                                      totalSucces: statisticsModel.totalSucces,
                                                      levelAttemps: statisticsModel.levelAttemps,
                                                      levelSuccess: statisticsModel.levelSuccess,
                                                      ranking: statisticsModel.ranking,
                                                      points: statisticsModel.points,
                                                      lastPlays: statisticsModel.lastPlays,
                                                      percentajeAccert: statisticsModel.percentajeAccert,
                                                      percentajeCapture: statisticsModel.percentajeCapture)

        XCTAssertNotNil(viewModel.levelText)
        
        viewModel.staticticsModel =  StatisticsModel(level: .dificult,
                                                      totalAttemps: statisticsModel.totalAttemps,
                                                      totalSucces: statisticsModel.totalSucces,
                                                      levelAttemps: statisticsModel.levelAttemps,
                                                      levelSuccess: statisticsModel.levelSuccess,
                                                      ranking: statisticsModel.ranking,
                                                      points: statisticsModel.points,
                                                      lastPlays: statisticsModel.lastPlays,
                                                      percentajeAccert: statisticsModel.percentajeAccert,
                                                      percentajeCapture: statisticsModel.percentajeCapture)

        XCTAssertNotNil(viewModel.levelText)
        
        
    }
    
    func testLevelMessage() {
        let message = viewModel.levelMessage
        XCTAssertEqual(message, Text("UpLevel"))
    }
    
    func testSuggestionText() {
        let suggestion = viewModel.suggestionText
        XCTAssertFalse(suggestion.isEmpty)
    }
    
    func testGetColor() {
        XCTAssertEqual(viewModel.getColor(for: 20), Color("LowLevel"))
        XCTAssertEqual(viewModel.getColor(for: 50), Color("MediumLevel"))
        XCTAssertEqual(viewModel.getColor(for: 80), Color("HardLevel"))
    }
    
    func testExportStatistics() {
        viewModel.exportStatistics()
        XCTAssertNotNil(viewModel.pdfURL)
        XCTAssertTrue(viewModel.showShareSheet)
    }
}
