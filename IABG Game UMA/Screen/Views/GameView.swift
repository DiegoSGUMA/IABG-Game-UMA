//
//  GameView.swift
//  IABG Game UMA
//
//  Created by Diego Sánchez on 25/12/24.
//

import SwiftUI
import SpriteKit
import GameKit

struct GameView: View {
    @Binding var path: [Constants.NavigationDestination]
    @ObservedObject var scene = GameScene()
    
    var body: some View {
        
        ZStack {
            
            SpriteView(scene: scene)
                .ignoresSafeArea()
            
            if scene.gameOver {
                Button {
                    path.append(.endGame(games: scene.resultElements))
                } label: {
                    Text("Ver resultados")
                }
                .buttonStyle(MainButton())
                .padding(40)
            }
        }
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    GameView(path: .constant([Constants.NavigationDestination.gameView]))
}
