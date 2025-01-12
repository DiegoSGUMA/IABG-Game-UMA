//
//  ContentView.swift
//  IABG Game UMA
//
//  Created by Diego Sánchez on 9/9/24.
//

import SwiftUI

struct ContentView: View {
    
    @State private var showSplach = true
    @State private var path: [Constants.NavigationDestination] = []
    
    
    var body: some View {
        ZStack {
            if showSplach {
                LottieView(name: "SplashGift.json")
                    .transition(.opacity)
            } else {
                MainMenuView(mainMenuVM: MainMenuVM(user: InfoUserModel(userName: "", profilePicture: "", ranking: 0, points: 0)))
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                withAnimation {
                    self.showSplach = false
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
