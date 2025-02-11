//
//  ProfileVMTest.swift
//  IABG Game UMA
//
//  Created by Diego Sánchez on 6/2/25.
//

import XCTest
@testable import IABG_Game_UMA

class ProfileVMTest: XCTestCase {
    
    var viewModel: ProfileVM!
    
    override func setUp() {
        super.setUp()
        
        let profileInfo = ProfileModel(userId: "123",
                                       userName: "TestUser",
                                       email: "test@example.com",
                                       passwordCount: 5,
                                       percentajeLevel: 6)
        
        viewModel = ProfileVM(profileInfo: profileInfo)
        
    }
    
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
    func testValidateNewPass_ValidPassword() {
        let validPassword = "StrongP@ss1"
        XCTAssertNil(viewModel.validateNewPass(validPassword))
    }
    
    func testValidateNewPass_InvalidPassword() {
        let invalidPassword = "weakpass"
        XCTAssertNotNil(viewModel.validateNewPass(invalidPassword))
    }
    
    func testValidateNewUsername_ValidUsername() {
        let validUsername = "ValidUsername"
        XCTAssertNil(viewModel.validateNewUsername(validUsername))
    }
    
    func testValidateNewUsername_InvalidUsername() {
        let invalidUsername = "Invalid Username"
        XCTAssertNotNil(viewModel.validateNewUsername(invalidUsername))
    }
    
    func testValidateFields_ValidData() {
        XCTAssertTrue(viewModel.validateFields(username: "ValidUser", password: "StrongP@ss1"))
    }
    
    func testValidateFields_InvalidData() {
        XCTAssertFalse(viewModel.validateFields(username: "Invalid Username", password: "weakpass"))
    }
    
    func testShowInfo() {
        viewModel.showInfo(message: "Test Message", info: true, logout: false)
        XCTAssertTrue(viewModel.showAlert)
        XCTAssertEqual(viewModel.msg, "Test Message")
        XCTAssertTrue(viewModel.infoOnly)
        XCTAssertFalse(viewModel.logOut)
    }
    
}
