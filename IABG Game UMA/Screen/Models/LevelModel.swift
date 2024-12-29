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
        return "Easy"
    case .medium:
        return "Medium"
    case .dificult:
        return "Dificult"
    case .none:
        return "None"
    }
}
