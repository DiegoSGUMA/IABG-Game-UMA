//
//  EndGameViewModel.swift
//  IABG Game UMA
//
//  Created by Diego Sánchez on 25/12/24.
//

import Foundation
import SwiftUI

final class EndGameVM: ObservableObject {
    
    @Published var elements: [EndGameModel]
    @Published var icons: [Int?] = Array(repeating: nil, count: 7) // Reemplaza icon1, icon2... con un array
    @Published var comprobe: Bool = false
    @Published var showAlert = false
    @Published var msg = ""
    
    var percentageGlobal: Double = 0
    var percentajeAccert: Double = 0
    var percentajeCapture: Double = 0
    var totalPredictions: Int = 0
    var totalRealResult: Int = 0
    
    private var resultRepository = EndGameAPI()
    
    init(elements: [EndGameModel]) {
        self.elements = elements
        self.resultRepository.delegate = self
    }
    
    func getTypes() -> [Int] {
        return elements.map { $0.index }
    }
    
    func save() {
        elements = elements.map { element in
            let possibleResult = icons[safe: element.index - 1] ?? 0
            return EndGameModel(index: element.index,
                                realResult: element.realResult,
                                totalElements: element.totalElements,
                                posibleResult: possibleResult ?? 0)
        }
        calculateAccert()
    }
    
    func calculateAccert() {
        var totalAccert: Double = 0
        var totalCollected: Double = 0
        
        elements.forEach { element in
            let corrector = min(element.posibleResult, element.realResult)
            let prediction = element.realResult > 0 ? Double(corrector) / Double(element.realResult) : 0
            let collected = Double(element.realResult) / Double(element.totalElements)
            
            totalAccert += prediction
            totalCollected += collected
            totalRealResult += element.realResult
            totalPredictions += corrector
        }
        
        let count = Double(elements.count)
        percentajeAccert = (totalAccert / count) * 100
        percentajeCapture = (totalCollected / count) * 100
        percentageGlobal = (percentajeAccert * 0.8) + (percentajeCapture * 0.2)
    }
    
    func saveResults() {
        guard let userInfo = UserDefaults.getUser() else {
            showInfo(error: NSLocalizedString("generic_error", comment: ""))
            return
        }
        let level = UserDefaults.getLevel().rawValue
        let model = EndGameRequestModel(userID: userInfo.userID,
                                        level: level,
                                        perPred: Int(percentajeAccert),
                                        perAgil: Int(percentajeCapture),
                                        globalPer: Int(percentageGlobal),
                                        totSuccess: totalRealResult,
                                        totPredict: totalPredictions)
        resultRepository.saveResults(results: model)
    }
    
    func bindingForIndex(array: Binding<[Int?]>, index: Int) -> Binding<Int> {
        return Binding<Int>(
            get: {
                guard index >= 0 && index < array.wrappedValue.count else { return 0 }
                return array.wrappedValue[index] ?? 0
            },
            set: { newValue in
                guard index >= 0 && index < array.wrappedValue.count else { return }
                array.wrappedValue[index] = newValue
            }
        )
    }

    func showInfo(error: String) {
        showAlert = true
        msg = error
    }
}

extension EndGameVM: EndGameApiDelegate {
    func saveResultSucces() {
        showInfo(error: NSLocalizedString("save_result_success", comment: ""))
    }
    
    func saveResultError(error: String) {
        showInfo(error: NSLocalizedString("generic_error", comment: ""))
    }
}

private extension Array {
    /// Safe index accessor to avoid out-of-bounds errors.
    subscript(safe index: Int) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
