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


// MARK: - Modelos por Defecto

extension StatisticsModel {
    /// Proporciona una instancia por defecto para inicializaciones rápidas.
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
    /// Proporciona una instancia por defecto para inicializaciones rápidas.
    static let `default` = ProfileModel(
        userId: "",
        userName: "Usuario",
        email: "usuario@erp.com",
        profilePicture: nil,
        passwordCount: 1,
        percentajeLevel: 0
    )
}
