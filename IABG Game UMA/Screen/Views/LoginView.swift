//
//  LoginView.swift
//  IABG Game UMA
//
//  Created by Diego Sánchez on 11/9/24.
//

import SwiftUI
import Firebase

struct LoginView: View {
    
    @Binding var path: [Constants.NavigationDestination]
    @ObservedObject var loginVM: LoginVM
    @State private var email = ""
    @State private var pass = ""

    var body: some View {
        VStack {
            logoView()
                .padding(50)
            
            Spacer()
            
            VStack(spacing: 16) {
                emailField
                passwordField
                
                forgotPasswordButton
                
                Spacer()
                
                loginButton
                registerButton
            }
            .padding(.horizontal, 16)
        }
        .toolbar(.hidden)
        .onReceive(loginVM.eventPublisher) { event in
            clearPathAfterDelay()
        }
        .alert("App Warning", isPresented: $loginVM.showAlert) {
        } message: {
            Text(loginVM.msg)
        }
    }
    
    private func clearPathAfterDelay() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            path.removeAll()
        }
    }

    // Subvistas
    private func logoView() -> some View {
        Image("cutIcon")
            .resizable()
            .aspectRatio(contentMode: .fit)
    }

    private var emailField: some View {
        FieldText(
            label: NSLocalizedString("Email", comment: ""),
            text: $email,
            secondPass: $email,
            validation: Validations.validateEmail,
            isPassword: false,
            isEmail: true
        )
        .keyboardType(.emailAddress)
    }

    private var passwordField: some View {
        FieldText(
            label: NSLocalizedString("Password", comment: ""),
            text: $pass,
            secondPass: $pass,
            validation: Validations.validatePass,
            isPassword: true
        )
        .textContentType(.password)
        .keyboardType(.default)
        .autocorrectionDisabled()
        .textInputAutocapitalization(.never)
    }

    private var forgotPasswordButton: some View {
        Button(action: {
            path.append(Constants.NavigationDestination.forgotView)
        }) {
            Text("Forgot_password_button")
                .foregroundStyle(Color("FirstGreen"))
        }
    }

    private var loginButton: some View {
        Button("Login") {
            handleLogin()
        }
        .buttonStyle(SecondaryButton())
        .padding(.top, 16)
    }

    private var registerButton: some View {
        Button("Register_Button") {
            path.append(Constants.NavigationDestination.registerView)
        }
        .buttonStyle(MainButton())
        .padding(.bottom, 20)
    }

    private func handleLogin() {
        if Validations.validateEmail(text: email, second: nil) == nil, Validations.validatePass(text: pass, second: nil) == nil {
            loginVM.login(email: email, password: pass)
        }
    }
}

#Preview {
    LoginView(path: .constant([Constants.NavigationDestination.loginViow]), loginVM: LoginVM(user: UserModel(userID: "", userName: "", pwd: "", email: "")))
}
