//
//  MainMenuVM.swift
//  IABG Game UMA
//
//  Created by Diego Sánchez on 22/12/24.
//

import SwiftUI
import FirebaseAuth

final class MainMenuVM: ObservableObject {
    @Published var user: InfoUserModel
    @Published var staticticsModel = StatisticsModel.default
    @Published var profileModel = ProfileModel.default
    @Published var isLoading = true
    @Published var showAlert = false
    @Published var msg = ""
    @Published var navigateToLogin = false
    
    private var mainRepository = MainMenuAPI()

    init(user: InfoUserModel) {
        self.user = user
        self.mainRepository.delegate = self
    }
    
    func getUser() {
        guard let userInfo = UserDefaults.getUser() else {
            navigateToLogin = true
            isLoading = false
            return
        }
        
        isLoading = true
        let model = UpdatePassModel(userID: userInfo.userID, pwd: userInfo.pwd)
        mainRepository.getUser(user: model)
    }
    
    func showError(error: String) {
        msg = error
        showAlert = true
    }
}

extension MainMenuVM: MainMenuApiDelegate {

    func getUserInfoSucces(model: GetUserAllInfoResult) {
        staticticsModel = StatisticsModel(
            level: levels(rawValue: model.statistics.Level_ID) ?? .easy,
            totalAttemps: model.statistics.Total_Attempt,
            totalSucces: model.statistics.Total_Success,
            levelAttemps: model.statistics.Total_Attempt_Level,
            levelSuccess: model.statistics.Total_Success_Level,
            ranking: model.statistics.Ranking,
            points: model.statistics.Points,
            lastPlays: model.statistics.Last_Plays,
            percentajeAccert: Float(model.statistics.Percentage_Succes),
            percentajeCapture: Float(model.statistics.Percentage_Agility)
        )
        
        profileModel = ProfileModel(
            userId: model.userInfo.User_ID,
            userName: model.userInfo.User_Name,
            email: model.userInfo.Email,
            profilePicture: model.userInfo.Profile_Picture,
            passwordCount: model.userInfo.Pass_Count,
            percentajeLevel: Double(model.statistics.Level)
        )
        
        isLoading = false
    }
    
    func getUserInfoError(error: String) {
        isLoading = false
        showError(error: error)
    }
    
    func updateProfileSucces() { }
    func updateProfileError(error: String) {
        showError(error: error)
    }
}


