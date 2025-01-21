//
//  ForgotPassView.swift
//  IABG Game UMA
//
//  Created by Diego Sánchez on 22/12/24.
//

import SwiftUI

struct ForgotPassView: View {
    
    @ObservedObject var loginVM: LoginVM
    @State private var resetPasswordToggle: Bool = false
    @State private var alertMessage: String = ""
    @Binding var path: [Constants.NavigationDestination]
    @State private var check = false
    
    var body: some View {
        VStack(spacing: 0) {
            headerBar
            
            Text(NSLocalizedString("Forgot_Subtitle", comment: ""))
                .padding(.top, 34)
                .padding(.horizontal, 16)
            

            form
            sendEmailButton
            .reusableCustomAlert( isPresented: $resetPasswordToggle,
                                    title: "App Info",
                                    message: alertMessage,
                                    buttonText: NSLocalizedString("Confirmar", comment: "")
            ){
                path.removeLast()
            }
        }
        .background(Color("SecondBlue"))
        .toolbar(.hidden)
    }
    
    
    // MARK: - Subviews
    
    private var headerBar: some View {
        HeaderBar(title: NSLocalizedString("Recover password", comment: "")) {
            path.removeLast()
        }
    }
    
    private var form: some View {
        Form {
            FieldText(
                label: NSLocalizedString("Email", comment: ""),
                text: $loginVM.email,
                secondPass: $loginVM.secondPass,
                validation: Validations.validateEmail,
                isPassword: false,
                isEmail: true,
                check: $check
            )
            .keyboardType(.emailAddress)
            .textInputAutocapitalization(.never)
        }
        .background(Color("SecondBlue"))
        .scrollContentBackground(.hidden)
        .scrollDisabled(true)
    }
    
    private var sendEmailButton: some View {
        ZStack {
            Button(action: handleSendEmail) {
                Text(NSLocalizedString("Send_Email", comment: ""))
            }
            .buttonStyle(MainButton())
            .padding(16)
        }
        .background(Color("SecondBlue"))
    }
    
    private func handleSendEmail() {
        Task {
            if let error = Validations.validateEmail(text: loginVM.email, second: nil) {
                showAlert(message: NSLocalizedString("Email", comment: "") + " " + NSLocalizedString("Invalid_field_error", comment: ""))
            } else {
                await loginVM.resetPassword(for: loginVM.save()) { result in
                    if result {
                        showAlert(message: NSLocalizedString("forgot_ok", comment: ""))
                    } else {
                        showAlert(message: NSLocalizedString("forgot_ko", comment: ""))
                    }
                }
            }
        }
    }
    
    private func showAlert(message: String) {
        alertMessage = message
        resetPasswordToggle.toggle()
    }
}

#Preview {
    ForgotPassView(
        loginVM: LoginVM(user: UserModel(userID: "", userName: "", pwd: "", email: "")),
        path: .constant([Constants.NavigationDestination.forgotView])
    )
}

