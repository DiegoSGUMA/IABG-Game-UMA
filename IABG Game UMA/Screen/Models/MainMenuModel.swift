//
//  MainMenuModel.swift
//  IABG Game UMA
//
//  Created by Diego Sánchez on 23/12/24.
//

import Foundation

struct InfoUserModel: Codable, Hashable {
    let userName: String
    let profilePicture: String?
    let ranking: Int
    let points: Int
}


struct StatisticsModel: Hashable {
    let level: levels
    let totalAttemps: Int
    let totalSucces: Int
    let levelAttemps: Int
    let levelSuccess: Int
    let ranking: Int
    let points: Int
    let lastPlays: [Int]
    let percentajeAccert: Float
    let percentajeCapture: Float
    
}

struct ProfileModel: Codable, Hashable {
    var userId: String
    var userName: String
    var email: String
    var profilePicture: String?
    var passwordCount: Int
    var percentajeLevel: Double
}

// MARK: - Modelos para los servicios de MainView

struct GetUserAllInfoResult: Codable, Hashable {
    let userInfo: User
    let statistics: StatisticsGame
}

struct User:  Codable, Hashable {
    var User_ID: String
    var Email: String
    var Password: String
    var User_Name: String
    var Profile_Picture: String
    var Pass_Count: Int
    var Level_Percentage : Int
}

struct StatisticsGame: Codable, Hashable {
    var Statistics_ID: Int
    var User_ID: String
    var Level: Int
    var Total_Attempt: Int
    var Total_Success: Int
    var Ranking: Int
    var Points: Int
    var Percentage_Succes: Int
    var Percentage_Agility: Int
    var Last_Plays: [Int]
    var Level_ID: Int
    var Total_Attempt_Level: Int
    var Total_Success_Level: Int
}

struct updateProfileRequest: Codable {
    var userName: String
    var pwd: String
    var email: String
    var image: String
}



// MARK: - Modelos por Defecto

extension StatisticsModel {

    static let `default` = StatisticsModel(
        level: .easy,
        totalAttemps: 0,
        totalSucces: 0,
        levelAttemps: 0,
        levelSuccess: 0,
        ranking: 0,
        points: 0,
        lastPlays: [0, 0, 0, 0],
        percentajeAccert: 0,
        percentajeCapture: 0
    )
}

extension ProfileModel {

    static let `default` = ProfileModel(
        userId: "",
        userName: "Usuario",
        email: "usuario@erp.com",
        profilePicture: nil,
        passwordCount: 1,
        percentajeLevel: 0
    )
}
