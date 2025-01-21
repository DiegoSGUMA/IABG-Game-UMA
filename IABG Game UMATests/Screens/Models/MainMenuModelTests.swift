//
//  MainMenuModelTests.swift
//  IABG Game UMA
//
//  Created by Diego Sánchez on 18/1/25.
//

import XCTest
@testable import IABG_Game_UMA

class MainMenuModelTests: XCTestCase {
    
    
    let userMock : User = User(User_ID: "User1",
                               Email: "user@user.com",
                               Password: "prueba",
                               User_Name: "User001",
                               Profile_Picture: "",
                               Pass_Count: 4,
                               Level_Percentage: 60)
    
    
    let statisticMock: StatisticsGame = StatisticsGame(Statistics_ID: 001,
                                                       User_ID: "User1",
                                                       Level: 2,
                                                       Total_Attempt: 2,
                                                       Total_Success: 3,
                                                       Ranking: 14,
                                                       Points: 12,
                                                       Percentage_Succes: 13,
                                                       Percentage_Agility: 99,
                                                       Last_Plays: [12,12,34,56,99],
                                                       Level_ID: 2,
                                                       Total_Attempt_Level: 12,
                                                       Total_Success_Level: 12)

    func testUpdateValues() {
        let model = InfoUserModel(userName: userMock.User_Name,
                                  profilePicture: nil,
                                  ranking: statisticMock.Ranking,
                                  points: statisticMock.Points)
        
        XCTAssertNotEqual(model.userName, "HOLA")
        XCTAssertNil(model.profilePicture)
        XCTAssertEqual(model.ranking, 14)
        XCTAssertEqual(model.points, 12)
    }
    
    func testsUpdaterProfileRequest() {
        let model = updateProfileRequest(userName: userMock.User_Name,
                                         pwd: userMock.Password,
                                         email: userMock.Email,
                                         image: "")
        
        XCTAssertNotEqual(model.userName, "HOLA")
        XCTAssertTrue(model.image.isEmpty)
        XCTAssertEqual(model.pwd, "prueba")
        XCTAssertEqual(model.email, "user@user.com")
    }
    
    func testStatisticsModel() {
        let model = StatisticsModel(level: .medium,
                                    totalAttemps: 2,
                                    totalSucces: 3,
                                    levelAttemps: 6,
                                    levelSuccess: 7,
                                    ranking: 16,
                                    points: 12,
                                    lastPlays: [12,12,34,56,99],
                                    percentajeAccert: 13.6,
                                    percentajeCapture: 99.9)
        

        
        
    }
}
