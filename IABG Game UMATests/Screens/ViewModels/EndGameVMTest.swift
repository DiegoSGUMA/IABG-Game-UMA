//
//  EndGameVMTest.swift
//  IABG Game UMA
//
//  Created by Diego Sánchez on 5/2/25.
//

import XCTest
@testable import IABG_Game_UMA

class EndGameVMTest: XCTestCase {
    
    var viewModel: EndGameVM!
    
    override func setUp() {
        super.setUp()
        let elements = [
            EndGameModel(index: 1, realResult: 3, totalElements: 10, posibleResult: 0),
            EndGameModel(index: 2, realResult: 5, totalElements: 15, posibleResult: 0)
        ]
        
        viewModel = EndGameVM(elements: elements)
    }
    
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
    func testGetTypes() {
        let types = viewModel.getTypes()
        XCTAssertEqual(types, [1, 2])
    }
    
    func testSave() {
        viewModel.icons = [3, 5, nil, nil, nil, nil, nil]
        viewModel.save()
        
        XCTAssertEqual(viewModel.elements[0].posibleResult, 3)
        XCTAssertEqual(viewModel.elements[1].posibleResult, 5)
    }
    
    func testCalculateAccert() {
        viewModel.icons = [3, 5, nil, nil, nil, nil, nil]
        viewModel.save()
        viewModel.calculateAccert()
        
        XCTAssertGreaterThanOrEqual(viewModel.percentajeAccert, 0)
        XCTAssertGreaterThanOrEqual(viewModel.percentajeCapture, 0)
        XCTAssertGreaterThanOrEqual(viewModel.percentageGlobal, 0)
    }
    
    func testSaveResultsWithoutUser() {
        viewModel.saveResults()
        
        XCTAssertFalse(viewModel.showAlert)
    }
    
    func testShowInfo() {
        viewModel.showInfo(error: "Error de prueba")
        XCTAssertTrue(viewModel.showAlert)
        XCTAssertEqual(viewModel.msg, "Error de prueba")
    }
}
