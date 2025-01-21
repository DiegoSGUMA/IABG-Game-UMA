//
//  Alert.swift
//  IABG Game UMA
//
//  Created by Diego Sánchez on 9/1/25.
//

import SwiftUI

struct ReusableCustomAlert: ViewModifier {
    @Binding var isPresented: Bool
    var title: String
    var message: String
    var buttonText: String
    var buttonAction: () -> Void = {}
    
    func body(content: Content) -> some View {
        ZStack {
            content
            
            if isPresented {
                ZStack {
                    Color.black.opacity(0.4).ignoresSafeArea()
                    
                    VStack(spacing: 20) {
                        Text(title)
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                        
                        Text(message)
                            .font(.body)
                            .foregroundColor(.black.opacity(0.8))
                            .multilineTextAlignment(.center)
                        
                        Button(action: {
                            buttonAction()
                            isPresented = false
                        }) {
                            Text(buttonText)
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.gray)
                                .cornerRadius(10)
                        }
                    }
                    .padding()
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color(red: 0.85, green: 0.92, blue: 1.0),
                                Color(red: 0.7, green: 0.8, blue: 0.95),
                                Color(red: 0.6, green: 0.7, blue: 0.8)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                        .cornerRadius(15)
                    )
                    .padding(.horizontal, 40)
                }
            }
        }
    }
}

 
 extension View {
     func reusableCustomAlert( isPresented: Binding<Bool>,
                               title: String,
                               message: String,
                               buttonText: String,
                               buttonAction: @escaping () -> Void = {} ) -> some View {
        self.modifier(
            ReusableCustomAlert( isPresented: isPresented,
                                 title: title,
                                 message: message,
                                 buttonText: buttonText,
                                 buttonAction: buttonAction
                               )
        )
     }
 }
