//
//  SplashView.swift
//  IABG Game UMA
//
//  Created by Diego Sánchez on 11/9/24.
//

import SwiftUI

struct SplashView: View {
    var body: some View {
        LottieView(name: "SplashGift.json")
            .transition(.opacity)
    }
}

#Preview {
    SplashView()
}

