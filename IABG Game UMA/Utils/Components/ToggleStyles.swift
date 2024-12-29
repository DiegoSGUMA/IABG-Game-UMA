//
//  ToggleStyles.swift
//  IABG Game UMA
//
//  Created by Diego Sánchez on 10/12/24.
//

import SwiftUI

struct checkboxTogleStyle: ToggleStyle {
    
    func makeBody(configuration: Configuration) -> some View {
        Button(action: {
            configuration.isOn.toggle()
        }, label: {
            HStack {
                Image(systemName: configuration.isOn ? "checkmark.square" : "square")
                    .foregroundColor(Color("FirstGreen"))
                configuration.label
            }
            .foregroundStyle(.black)
        })
    }
}
