//
//  MainMenuVMTests.swift
//  IABG Game UMA
//
//  Created by Diego Sánchez on 18/1/25.
//

import XCTest
@testable import IABG_Game_UMA

class MainMenuVMTests: XCTestCase {
    
    var viewModel: MainMenuVM!
    
    override func setUp() {
        super.setUp()
        viewModel = MainMenuVM(user: InfoUserModel(userName: "Test", profilePicture: nil, ranking: 4, points: 144))
    }
    
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
    func testInitialState() {
        XCTAssertEqual(viewModel.user.points, 144)
        XCTAssertEqual(viewModel.staticticsModel.level, .easy)
        XCTAssertEqual(viewModel.profileModel.passwordCount, 1)
    }
    
    func testAddingDataUpdatesStatistics() {
        viewModel.staticticsModel = getStatisticaModelMock()
        viewModel.user =  getInfoUserModel()
        viewModel.profileModel = getProfileModelMock()
        
        XCTAssertEqual(viewModel.user.points, 12)
        XCTAssertEqual(viewModel.staticticsModel.level, .medium)
        XCTAssertEqual(viewModel.profileModel.passwordCount, 4)
    }
    
    func testGetUsers() {
        UserDefaults.deleteUser()
        viewModel.getUser()
        XCTAssertTrue(viewModel.navigateToLogin)
        XCTAssertFalse(viewModel.isLoading)
    }
    
    func testGetUserError() {
        viewModel.getUserInfoError(error: "Error en el servicio")
        
        XCTAssertEqual(viewModel.msg, "Error en el servicio")
        XCTAssertTrue(viewModel.showAlert)
        XCTAssertFalse(viewModel.isLoading)
    }
    
}
