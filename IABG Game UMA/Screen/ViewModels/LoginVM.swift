//
//  LoginVM.swift
//  IABG Game UMA
//
//  Created by Diego Sánchez on 7/10/24.
//

import SwiftUI
import Combine
import FirebaseAuth

final class LoginVM: ObservableObject {
    @Published var user: UserModel
    @Published var email: String = ""
    @Published var pass: String = ""
    @Published var secondPass: String = ""
    @Published var userName: String = ""
    @Published var showAlert = false
    @Published var gprdConditions = false
    @Published var msg = ""
    @Published var loginToggle = false
    @Published var isLoading = false
    @Published var navigateToLogin = false
    @Published var pdfURL: URL?
    
    let eventPublisher = PassthroughSubject<Bool, Never>()
    private let errorData = NSLocalizedString("Server_data_error", comment: "")
    var userRepository = LoginAPI()
    var userProvisionalModel: UserModel = UserModel(userID: "", userName: "", pwd: "", email: "")
    
    init(user: UserModel) {
        self.user = user
        userRepository.delegate = self
    }
    
    // MARK: - Login & Register Functions
    
    func login(email: String, password: String) {
        isLoading = true
        let formattedEmail = email.lowercased()
        Auth.auth().signIn(withEmail: formattedEmail, password: password) { result, error in
            if let user = result?.user {
                let userModel = UserModel(userID: user.uid, userName: "", pwd: password, email: formattedEmail)
                self.userRepository.updatePass(model: userModel)
            } else {
                self.isLoading = false
                self.showError(error: self.errorData)
            }
        }
    }
    
    func registerUser(userModel: UserModel) {
        userProvisionalModel = userModel
        userRepository.checkUsername(userName: userModel.userName)
    }
    
    func registerUserServices() {
        let userModel = save()
        Auth.auth().createUser(withEmail: userModel.email.lowercased(), password: userModel.pwd) { result, error in
            if let user = result?.user {
                let model = UserModel(
                    userID: user.uid,
                    userName: userModel.userName.uppercased(),
                    pwd: userModel.pwd,
                    email: userModel.email.lowercased()
                )
                self.userRepository.registerUser(user: model)
            } else {
                self.isLoading = false
                self.showError(error: self.errorData)
            }
        }
    }
    
    func resetPassword(for user: UserModel, completion: @escaping (Bool) -> Void) async {
        Auth.auth().sendPasswordReset(withEmail: user.email) { error in
            if error == nil {
                completion(true)
            } else {
                self.showError(error: NSLocalizedString("Server_error_email", comment: ""))
                completion(false)
            }
        }
    }
    
    func deleteUserFirebase() {
        Auth.auth().currentUser?.delete { error in
            if error == nil {
                print("El usuario se ha eliminado de Firebase")
            } else {
                print("El usuario no se ha podido eliminar de Firebase")
            }
        }
    }
    
    func save() -> UserModel {
        return UserModel(userID: "", userName: userName, pwd: pass, email: email)
    }
    
    func showError(error: String) {
        msg = error
        showAlert.toggle()
    }
    
    func allValidate() -> Bool {
        let fieldsToValidate = [userName, email, pass, secondPass]
        if Validations.validateEmpty(fields: fieldsToValidate) != nil ||
            Validations.validateUsername(text: userName, second: nil) != nil ||
            Validations.validateEmail(text: email, second: nil) != nil ||
            Validations.validatePass(text: pass, second: nil) != nil ||
            Validations.validateEqualPass(pass1: pass, pass2: secondPass) != nil ||
            !gprdConditions {
            return false
        }
        return true
    }
    
    func startRegistrationProcess() {
        guard allValidate() else {
            showError(error: NSLocalizedString("Invalid_request_field", comment: ""))
            return }
        isLoading = true
        registerUser(userModel: save())
    }
}

// MARK: - LoginAPI Delegate Methods

extension LoginVM: LoginApiDelegate {
    
    func updatePassSuccess() {
        
        isLoading = false
        loginToggle.toggle()
        eventPublisher.send(true)
    }
    
    func updatePassError(error: String) {
        do {
            try Auth.auth().signOut()
            isLoading = false
            showError(error: error)
            
        } catch let signOutError as NSError {
            isLoading = false
            showError(error: signOutError.localizedDescription)
        }
    }
    
    func isUserNameValidSuccess() {
        registerUserServices()
    }
    
    func isUserNameValidError(error: String) {
        isLoading = false
        showError(error: error)
    }
    
    func registerUserSuccess() {
        isLoading = false
        navigateToLogin = true
        showError(error: NSLocalizedString("Register_user_ok", comment: ""))
    }
    
    func registerUserError(error: String) {
        isLoading = false
        deleteUserFirebase()
        showError(error: error)
    }
}
