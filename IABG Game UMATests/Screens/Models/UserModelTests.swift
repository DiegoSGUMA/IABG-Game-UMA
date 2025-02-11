//
//  UserModelTests.swift
//  IABG Game UMA
//
//  Created by Diego Sánchez on 4/2/25.
//

import XCTest
@testable import IABG_Game_UMA

class UserModelTests: XCTestCase {
    
    func testUserModel() {
        let umodel: UserModel = UserModel(userID: "User01",
                                         userName: "Username",
                                         pwd: "User",
                                         email: "User@user.com")
        
        let nameValid: IsUserNameValiRequestModel = IsUserNameValiRequestModel(userName: "Username")
        
        XCTAssertNotEqual(umodel.userID, "User02")
        XCTAssertEqual(umodel.userName, "Username")
        XCTAssertNotEqual(umodel.pwd, "User0")
        XCTAssertEqual(umodel.email, "User@user.com")
        XCTAssertNotEqual(nameValid.userName, "User")
    }
    
    func testsEndGameRequestModel() {
        let updateModel: UpdatePassModel = UpdatePassModel(userID: "User03", pwd: "pwd")

        XCTAssertTrue(updateModel.userID == "User03")
        XCTAssertNotEqual(updateModel.pwd, "pwd1")
    }
    
    
}
