//
//  LoginVMTests.swift
//  IABG Game UMA
//
//  Created by Diego Sánchez on 4/2/25.
//

import XCTest
@testable import IABG_Game_UMA

class LoginVMTests: XCTestCase {
    
    var viewModel: LoginVM!
    
    override func setUp() {
        super.setUp()
        viewModel =  LoginVM(user: UserModel(userID: "User01",
                                             userName: "User0101",
                                             pwd: "Userpwd",
                                             email: "user@username.com"))
    }
    
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
    func testInitialState() {
        XCTAssertEqual(viewModel.user.userID, "User01")
        XCTAssertEqual(viewModel.user.userName, "User0101")
        XCTAssertEqual(viewModel.user.pwd, "Userpwd")
        XCTAssertNotEqual(viewModel.user.email, "user@username.es")
    }
    
    func testLoginUserFailed() {
        viewModel.msg = ""
        viewModel.email = ""
        let user = getUserMock()
        
        
        viewModel.registerUser(userModel: UserModel(userID: user.User_ID,
                                                    userName: user.User_Name,
                                                    pwd: user.Password,
                                                    email: user.Email))
        
        XCTAssertTrue(!viewModel.errorData.isEmpty)
    }
    
    func testRegisterUser() {
        
        viewModel.login(email: viewModel.email, password: viewModel.pass)
        
        XCTAssertTrue(!viewModel.errorData.isEmpty)
    }
    
    func testRegisterUserService() {
        let user = getUserMock()
        
        viewModel.userName = user.User_Name
        viewModel.pass = user.Password
        viewModel.email = user.Email
        
        viewModel.registerUserSuccess()
        
        XCTAssertTrue(!viewModel.errorData.isEmpty)
    }
    
    func testResetAndDeleteUser() {
        let user = getUserMock()
        var comprobation : Bool = true
        Task {
            await viewModel.resetPassword(for: viewModel.save()) { result in
                comprobation = result
            }
        }
        viewModel.deleteUserFirebase()
        
        XCTAssertTrue(comprobation)
        
    }
    
    func testAllvalidations() {
        let user = getUserMock()
        var validate = viewModel.allValidate()
        viewModel.startRegistrationProcess()
        
        XCTAssertFalse(validate)
        
    }
    

    
}
