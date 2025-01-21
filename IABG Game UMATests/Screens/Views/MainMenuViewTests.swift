//
//  MainMenuViewTests.swift
//  IABG Game UMA
//
//  Created by Diego Sánchez on 19/1/25.
//

import Foundation

import XCTest
import SwiftUI
@testable import IABG_Game_UMA

class MainMenuViewTests: XCTestCase {
    
    @State private var path: [Constants.NavigationDestination] = []
    @ObservedObject var mainMenuVM = MainMenuVM(user: InfoUserModel(userName: "", profilePicture: "", ranking: 101, points: 0))
    
    
    func testViewBody(){
        let view = MainMenuView(mainMenuVM: mainMenuVM)
        let env = EnvironmentValues()
        let instance = view.body
        
        XCTAssertEqual(view.path, [])
    }
}
