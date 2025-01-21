//
//  Constants.swift
//  IABG Game UMA
//
//  Created by Diego Sánchez on 7/10/24.
//

import Foundation

struct Constants {
    static var navigateToHome : Bool = false
    
    struct ApiConstants {
        static let getUserInfo = "getUserAllInfo"
        static let registerUser = "registerUser"
        static let usernameValid = "isUserNameValid"
        static let updatePass = "updatePass"
        static let updateProfile = "updateProfile"
        static let saveResult = "saveResults"
    }
    
    enum NavigationDestination: Hashable {
        case loginView
        case registerView
        case forgotView
        case statisticsView(statictics: StatisticsModel)
        case profileView(profile: ProfileModel)
        case gameView
        case endGame(games: [EndGameModel])
    }
}
