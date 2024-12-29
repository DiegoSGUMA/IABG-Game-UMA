//
//  StatisticsVM.swift
//  IABG Game UMA
//
//  Created by Diego Sánchez on 28/12/24.
//

import SwiftUI

final class StatisticsVM: ObservableObject {
    @Published var staticticsModel: StatisticsModel

    init(staticticsModel: StatisticsModel) {
        self.staticticsModel = staticticsModel
    }

    var levelText: Text {
        switch staticticsModel.level {
        case .easy, .none:
            return createText("Easy", color: Color("LowLevel"))
        case .medium:
            return createText("Medium", color: Color("MediumLevel"))
        case .dificult:
            return createText("Hard", color: Color("HardLevel"))
        }
    }

    var levelMessage: Text {
        switch staticticsModel.level {
        case .easy, .none: return Text("Improve")
        case .medium: return Text("UpLevel")
        case .dificult: return Text("Go")
        }
    }

    var suggestionText: String {
        let accuracy = staticticsModel.levelAttemps == 0
            ? 0
            : staticticsModel.levelSuccess * 100 / staticticsModel.levelAttemps

        let (badKey, goodKey): (String, String) = {
            switch staticticsModel.level {
            case .easy, .none: return ("EasyBad", "EasyGood")
            case .medium: return ("MediumBad", "MediumGood")
            case .dificult: return ("HardBad", "HardGood")
            }
        }()
        
        return NSLocalizedString(accuracy <= 50 ? badKey : goodKey, comment: "")
    }

    func getColor(for point: Int) -> Color {
        switch point {
        case ..<36: return Color("LowLevel")
        case ..<76: return Color("MediumLevel")
        default: return Color("HardLevel")
        }
    }
    
    private func createText(_ text: String, color: Color) -> Text {
        Text(text).foregroundStyle(color)
    }
}
