//
//  Alert.swift
//  IABG Game UMA
//
//  Created by Diego Sánchez on 9/1/25.
//

import SwiftUI

struct ReusableAlert: ViewModifier {
    @Binding var isPresented: Bool
    var title: String
    var message: String
    var buttonText: String
    var buttonAction: () -> Void = {}

    func body(content: Content) -> some View {
        content
            .alert(isPresented: $isPresented) {
                Alert(
                    title: Text(title)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.red),
                    message: Text(message)
                        .font(.body)
                        .foregroundColor(.gray),
                    dismissButton: .cancel(
                        Text(buttonText)
,
                        action: buttonAction
                    )
                )
            }
    }
}

extension View {
    func reusableAlert(
        isPresented: Binding<Bool>,
        title: String,
        message: String,
        buttonText: String,
        buttonAction: @escaping () -> Void = {}
    ) -> some View {
        self.modifier(
            ReusableAlert(
                isPresented: isPresented,
                title: title,
                message: message,
                buttonText: buttonText,
                buttonAction: buttonAction
            )
        )
    }
}


//SI ME DA TIEMPO, CREAR UNA ALERTA PERSONALIZADA COMO LA SIGUIENTE YA QUE LA DE ARRIBA NO PUEDE PERSONALIZARSE MÁS Y ES BÁSICA
/*
 ALERTA
 
 import SwiftUI
 
 struct ReusableCustomAlert: ViewModifier {
 @Binding var isPresented: Bool
 var title: String
 var message: String
 var buttonText: String
 var backgroundColor: Color
 var buttonAction: () -> Void = {}
 
 func body(content: Content) -> some View {
 ZStack {
 content
 
 if isPresented {
 ZStack {
 // Fondo oscuro para el fondo de la alerta
 Color.black.opacity(0.4).ignoresSafeArea()
 
 // Cuerpo de la alerta
 VStack(spacing: 20) {
 Text(title)
 .font(.title2)
 .fontWeight(.bold)
 .foregroundColor(.white)
 
 Text(message)
 .font(.body)
 .foregroundColor(.white.opacity(0.9))
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
 .background(Color.blue)
 .cornerRadius(10)
 }
 }
 .padding()
 .background(backgroundColor)
 .cornerRadius(15)
 .padding(.horizontal, 40)
 }
 }
 }
 }
 }
 
 extension View {
 func reusableCustomAlert(
 isPresented: Binding<Bool>,
 title: String,
 message: String,
 buttonText: String,
 backgroundColor: Color = Color.gray,
 buttonAction: @escaping () -> Void = {}
 ) -> some View {
 self.modifier(
 ReusableCustomAlert(
 isPresented: isPresented,
 title: title,
 message: message,
 buttonText: buttonText,
 backgroundColor: backgroundColor,
 buttonAction: buttonAction
 )
 )
 }
 }
 
 
 
 //COMO USARLA
 
 struct ContentView: View {
 @State private var showAlert = false
 
 var body: some View {
 VStack {
 Button("Mostrar Alerta") {
 showAlert = true
 }
 .font(.headline)
 .foregroundColor(.white)
 .padding()
 .background(Color.blue)
 .cornerRadius(8)
 }
 .reusableCustomAlert(
 isPresented: $showAlert,
 title: "Alerta Personalizada",
 message: "Este es un mensaje con un fondo distinto.",
 buttonText: "Aceptar",
 backgroundColor: Color.red
 ) {
 print("Botón presionado")
 }
 }
 }
 
 struct ContentView_Previews: PreviewProvider {
 static var previews: some View {
 ContentView()
 }
 }
 */
