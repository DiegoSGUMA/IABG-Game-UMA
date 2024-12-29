//
//  TextField.swift
//  IABG Game UMA
//
//  Created by Diego Sánchez on 7/10/24.
//

import SwiftUI
import Combine

struct FieldText: View {
    
    let label: String
    @Binding var text: String
    @Binding var secondPass: String 
    let validation: (String, String?) -> String?
    let isPassword: Bool
    
    @State private var error = false
    @State private var errorMsg = ""
    @State private var showPass = false
    @State var isEmail = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(label)
                .font(.headline)
                .padding(.leading, 10)
            
            HStack {
                if isPassword {
                    passwordField
                } else {
                    standardField
                }
            }
            .padding(10)
            .background(RoundedRectangle(cornerRadius: 10, style: .continuous).fill(Color(white: 0.97)))
            .overlay(validationOverlay)
            
            if error {
                Text("\(label) \(errorMsg).")
                    .font(.caption2)
                    .foregroundStyle(.red)
                    .bold()
                    .padding(.leading, 10)
            }
        }
        .onChange(of: text) { _ in validate() }
    }
    
    // MARK: - Subviews
    
    @ViewBuilder
    private var passwordField: some View {
        Group {
            if showPass {
                TextField("Enter the \(label)", text: $text)
            } else {
                SecureField("Enter the \(label)", text: $text)
            }
        }
        Button {
            showPass.toggle()
        } label: {
            Image(systemName: showPass ? "eye.slash" : "eye")
                .symbolVariant(.fill)
                .symbolVariant(.circle)
        }
        .buttonStyle(.plain)
        .opacity(text.isEmpty ? 0.0 : 0.3)
    }
    
    @ViewBuilder
    private var standardField: some View {
        TextField("Enter the \(label)", text: $text)
        Button {
            text = ""
        } label: {
            Image(systemName: "xmark")
                .symbolVariant(.fill)
                .symbolVariant(.circle)
        }
        .buttonStyle(.plain)
        .opacity(text.isEmpty ? 0.0 : 0.3)
        
        if isEmail {
            Image(systemName: "envelope.fill")
                .frame(width: 25, height: 25)
                .aspectRatio(contentMode: .fill)
        }
    }
    
    private var validationOverlay: some View {
        RoundedRectangle(cornerRadius: 10, style: .continuous)
            .stroke(lineWidth: 2)
            .fill(error ? Color.red : Color.clear)
    }
    
    // MARK: - Methods
    
    private func validate() {
        if let message = validation(text, secondPass) {
            errorMsg = message
            error = true
        } else {
            error = false
        }
    }
}
