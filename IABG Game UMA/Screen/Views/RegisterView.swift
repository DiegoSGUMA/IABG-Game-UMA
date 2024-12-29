//
//  RegisterView.swift
//  IABG Game UMA
//
//  Created by Diego Sánchez on 20/11/24.
//


import SwiftUI

struct RegisterView: View {
    @Binding var path: [Constants.NavigationDestination]
    @FocusState var field: Fields?
    @ObservedObject var loginVM: LoginVM

    var body: some View {
        if loginVM.isLoading {
            ProgressView()
                .toolbar(.hidden)
        } else {
            VStack(spacing: 0) {
                Text("Hola")
                HeaderBar(title: NSLocalizedString("Register", comment: "")) {
                    path.removeLast()
                }
                

               Form {
                    FormSection(header: "Personal_Detail") {
                        FieldText(
                            label: NSLocalizedString("Username", comment: ""),
                            text: $loginVM.userName,
                            secondPass: $loginVM.secondPass,
                            validation: Validations.validateUsername,
                            isPassword: false
                        )
                        .textContentType(.username)
                        .focused($field, equals: .username)
                        .submitLabel(.next)
                        .onSubmit { field?.next() }

                        FieldText(
                            label: NSLocalizedString("Email", comment: ""),
                            text: $loginVM.email,
                            secondPass: $loginVM.secondPass,
                            validation: Validations.validateEmail,
                            isPassword: false
                        )
                        .textContentType(.emailAddress)
                        .focused($field, equals: .email)
                        .submitLabel(.next)
                        .onSubmit { field?.next() }
                    }

                    FormSection(header: "Password") {
                        FieldText(
                            label: NSLocalizedString("Password", comment: ""),
                            text: $loginVM.pass,
                            secondPass: $loginVM.secondPass,
                            validation: Validations.validatePass,
                            isPassword: true
                        )
                        .focused($field, equals: .pass)
                        .submitLabel(.next)
                        .onSubmit { field?.next() }

                        FieldText(
                            label: NSLocalizedString("Confirm Password", comment: ""),
                            text: $loginVM.secondPass,
                            secondPass: $loginVM.pass,
                            validation: Validations.validateEqualPass,
                            isPassword: true
                        )
                        .focused($field, equals: .secondpass)
                        .submitLabel(.next)
                        .onSubmit { field?.next() }
                    }

                    FormSection(header: "Conditions") {
                        Toggle(isOn: $loginVM.gprdConditions) {
                            Text("Aceptar términos y condiciones para todos los datos necesarios de los usuarios.")
                        }
                        .toggleStyle(checkboxTogleStyle())
                    }
                }
                .background(Color("SecondBlue"))
                .scrollContentBackground(.hidden)

                MainActionButton(title: "Register_Button", isEnabled: loginVM.allValidate()) {
                    loginVM.startRegistrationProcess()
                }
                .background(Color("SecondBlue"))
            }
            .toolbar(.hidden)
            .alert("App Warning", isPresented: $loginVM.showAlert) {
                Button("OK", role: .cancel) {
                    if loginVM.navigateToLogin {
                        path.removeAll()
                    }
                }
            } message: {
                Text(loginVM.msg)
            }
            .onAppear()
            {
                print("Holaaa")
            }
        }
    }
}

#Preview {
    RegisterView(path: .constant([Constants.NavigationDestination.registerView]), loginVM: LoginVM(user: UserModel(userID: "", userName: "", pwd: "", email: "")))
}


// MARK: - Register components

struct FormSection<Content: View>: View {
    let header: String
    let content: Content

    init(header: String, @ViewBuilder content: () -> Content) {
        self.header = header
        self.content = content()
    }

    var body: some View {
        Section {
            content
        } header: {
            Text(header)
        }
    }
}


enum Fields: Hashable {
    case username, email, pass, secondpass

    func next() -> Fields? {
        switch self {
        case .username: return .email
        case .email: return .pass
        case .pass: return .secondpass
        case .secondpass: return nil
        }
    }
}

extension Fields {
    static func initialFocus() -> Fields? { .username }
}


struct MainActionButton: View {
    let title: String
    let isEnabled: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
        }
        .buttonStyle(MainButton())
        .disabled(!isEnabled)
        .padding(16)
    }
}




