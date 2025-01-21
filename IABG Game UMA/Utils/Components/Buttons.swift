//
//  Buttons.swift
//  IABG Game UMA
//
//  Created by Diego Sánchez on 7/10/24.
//

import SwiftUI


struct MainButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .lineLimit(2)
            .frame(maxWidth: .infinity)
            .background(Color("FirstBlue"))
            .foregroundColor(.white)
            .cornerRadius(8)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}


struct SecondaryButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.white)
            .foregroundColor(Color("FirstBlue"))
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color("FirstBlue"), lineWidth: 2)
            )
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}

struct ThirdButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color("FirstGreen"))
            .foregroundColor(.white)
            .cornerRadius(8)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}

struct LevelButton: ButtonStyle {
    
    var type: levels
    var isSelected: Bool
    
    func getColor() -> Color {
        switch type {
        case .easy, .none:
            return Color("Button_easy")
        case .medium:
            return Color("Button_Medium")
        case .dificult:
            return Color("FirstBlue")
        }
    }
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.label
                .font(.system(size: 15))
                .fontWeight(.black)
                .background(getColor())
                .padding(10)
                .frame(width: UIScreen.main.bounds.width - 50)
                .cornerRadius(8)
                .overlay {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(lineWidth: isSelected ? 3 : 0)
                }
                .background(getColor())
                .scaleEffect(configuration.isPressed ? 1.2 : 1)
                .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
        }
    }
}

