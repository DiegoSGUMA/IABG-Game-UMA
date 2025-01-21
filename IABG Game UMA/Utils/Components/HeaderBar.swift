//
//  HeaderBar.swift
//  IABG Game UMA
//
//  Created by Diego Sánchez on 10/12/24.
//

import SwiftUI

struct HeaderBar: View {
    
    var title: String
    var onBack: () -> Void
    
    var body: some View {
        HStack {
            Button(action: {
                onBack()
            }) {
                Image(systemName: "arrow.left")
                    .foregroundColor(Color("FirstGreen"))
                    .padding()
            }
            Spacer()
            Text(title)
                .font(.title3)
                .foregroundColor(.black)
            Spacer()
            Spacer().frame(width: 44)
        }
        .padding(.vertical, 10)
        .background(Color.white)
        .overlay(Rectangle().frame(height: 1).padding(.top, 44).tint(.gray), alignment: .bottom)
    }
}

func prueba() -> Void {
    
}

#Preview {
    HeaderBar(title: "Cabecera", onBack: prueba)
}
