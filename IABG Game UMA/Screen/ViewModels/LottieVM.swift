//
//  LottieVM.swift
//  IABG Game UMA
//
//  Created by Diego Sánchez on 11/9/24.
//


import SwiftUI
import Lottie

struct LottieView: UIViewRepresentable {
    
    let name: String
    
    func makeUIView(context: Context) -> Lottie.LottieAnimationView {
        let animationView = LottieAnimationView(name: name)
        animationView.play()
        return animationView
        
    }
    
    func updateUIView(_ uiView: Lottie.LottieAnimationView, context: Context) { }
}
