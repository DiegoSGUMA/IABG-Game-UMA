//
//  MainMenuVMMock.swift
//  IABG Game UMA
//
//  Created by Diego Sánchez on 18/1/25.
//

func getUserMock() -> User {
    return User(User_ID: "User1",
                               Email: "user@user.com",
                               Password: "prueba",
                               User_Name: "User001",
                               Profile_Picture: "",
                               Pass_Count: 4,
                               Level_Percentage: 60)
}

func getStatisticsGameMock() -> StatisticsGame {
    return StatisticsGame(Statistics_ID: 001,
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
}

func getProfileModelMock() -> ProfileModel {
    return ProfileModel(userId: "User1",
                        userName: "User001",
                        email: "user@user.com",
                        profilePicture: nil,
                        passwordCount: 4,
                        percentajeLevel: 60)
    
}

func getInfoUserModel() -> InfoUserModel {
    return InfoUserModel(userName: "User001",
                         profilePicture: nil,
                         ranking: 14,
                         points: 12)
}

func getStatisticaModelMock() -> StatisticsModel {
    return StatisticsModel(level: .medium,
                           totalAttemps: 2,
                           totalSucces: 2,
                           levelAttemps: 2,
                           levelSuccess: 3,
                           ranking: 3,
                           points: 12,
                           lastPlays: [12,12,34,56,99],
                           percentajeAccert: 15.5,
                           percentajeCapture: 10.8)
}
