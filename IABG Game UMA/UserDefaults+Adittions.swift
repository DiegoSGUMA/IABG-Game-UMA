//
//  UserDefaults+Adittions.swift
//  IABG Game UMA
//
//  Created by Diego Sánchez on 11/9/24.
//

import Foundation

extension UserDefaults {
    
    static let profileInfo = "profileInfo"
    static let levelGame = "levelGame"
    static let userInfo = "userInfo"

    static func getLevel() -> levels {
        return levels(rawValue: UserDefaults.standard.integer(forKey: levelGame)) ?? .none
    }

    static func setLevel(value: Int) {
        UserDefaults.standard.set(value, forKey: levelGame)
    }
    
    static func saveUser(user: UserModel) {
        if let encodedUser = try? JSONEncoder().encode(user) {
            UserDefaults.standard.set(encodedUser, forKey: userInfo)
        }
    }
    
    static func deleteUser() {
        UserDefaults.standard.removeObject(forKey: userInfo)
    }
    
    static func getUser() -> UserModel? {
        
        if let userInfo = UserDefaults.standard.data(forKey: userInfo) {
            do {
                let decoder = JSONDecoder()
                let info = try decoder.decode(UserModel.self, from: userInfo)
                return info
            } catch {
                return nil
            }
        } else {
            return nil
        }
    }
    
}
