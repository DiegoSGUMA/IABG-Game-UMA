//
//  GameModel.swift
//  IABG Game UMA
//
//  Created by Diego Sánchez on 25/12/24.
//

import Foundation


struct EndGameModel: Hashable {
    let index: Int
    let realResult: Int
    let totalElements: Int
    let posibleResult: Int
    
}

struct EndGameRequestModel: Hashable {
    let userID: String
    let level: Int
    let perPred: Int
    let perAgil: Int
    let globalPer: Int
    let totSuccess: Int
    let totPredict: Int
}
