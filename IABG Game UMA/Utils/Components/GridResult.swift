//
//  GridResult.swift
//  IABG Game UMA
//
//  Created by Diego Sánchez on 25/12/24.
//

import SwiftUI

struct GridResultView: View {
    let element: EndGameModel
    @Binding var result: Int
    @Binding var checked: Bool

    var body: some View {
        HStack {
            Image("game_\(element.index)")
                .resizable()
                .scaledToFit()
                .frame(width: 60, height: 60)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.black, lineWidth: 2))
            
            Spacer(minLength: 20)
            
            Group {
                if checked {
                    checkedResultView
                } else {
                    editableResultView
                }
            }
            .frame(width: checked ? 140 : 100, height: 50)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
        .background(backgroundColor)
        .cornerRadius(10)
    }

    private var checkedResultView: some View {
        VStack(alignment: .leading) {
            Text("\(result ?? 0) - \(element.realResult)")
            Text("**Total:** \(element.totalElements)")
        }
        .font(.body)
    }

    private var editableResultView: some View {
        TextField("", value: $result, format: .number)
            .cornerRadius(10)
            .multilineTextAlignment(.center)
            .textFieldStyle(.roundedBorder)
            .keyboardType(.numberPad)
            .submitLabel(.done)
    }

    private var backgroundColor: Color {
        if !checked {
            return Color("HardLevel")
        } else if result == element.realResult {
            return result == element.totalElements ? Color("HardLevel") : Color("MediumLevel")
        } else {
            return Color("LowLevel")
        }
    }
}

#Preview {
    GridResultView(
        element: EndGameModel(index: 3, realResult: 23, totalElements: 24, posibleResult: 3),
        result: .constant(21),
        checked: .constant(true)
    )
}
