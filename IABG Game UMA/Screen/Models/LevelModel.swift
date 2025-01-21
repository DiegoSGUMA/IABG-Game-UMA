//
//  Level.swift
//  IABG Game UMA
//
//  Created by Diego Sánchez on 11/9/24.
//

import Foundation

enum levels: Int {
    case easy = 1
    case medium = 2
    case dificult = 3
    case none = 0
}

func getLevelName(_ level: levels) -> String {
    switch level {
    case .easy:
        return NSLocalizedString("Easy", comment: "")
    case .medium:
        return NSLocalizedString("Medium", comment: "")
    case .dificult:
        return NSLocalizedString("Hard", comment: "")
    case .none:
        return "None"
    }
}
