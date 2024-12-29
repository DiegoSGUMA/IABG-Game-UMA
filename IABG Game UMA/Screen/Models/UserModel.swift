//
//  UserModel.swift
//  IABG Game UMA
//
//  Created by Diego Sánchez on 11/9/24.
//

import Foundation

struct UserModel: Codable, Hashable {
    let userID: String
    let userName: String
    let pwd: String
    let email: String
}

struct IsUserNameValiRequestModel: Codable {
    let userName: String
}

struct UpdatePassModel: Codable {
    let userID: String
    let pwd: String
}
