//
//  ProfileVM.swift
//  IABG Game UMA
//
//  Created by Diego Sánchez on 28/12/24.
//

import FirebaseAuth
import SwiftUI
import PhotosUI

final class ProfileVM: ObservableObject {
    @Published var profileInfo: ProfileModel
    @Published private(set) var selectedImage: UIImage? = nil
    @Published var changeImage = false
    @Published var imageSelector: PhotosPickerItem? = nil {
        didSet { processSelectedImage() }
    }
    @Published var isLoading = false
    @Published var showAlert = false
    @Published var infoOnly = false
    @Published var logOut = false
    @Published var msg = ""

    private var mainRepository = MainMenuAPI()

    init(profileInfo: ProfileModel) {
        self.profileInfo = profileInfo
        self.mainRepository.delegate = self
    }

    private func processSelectedImage() {
        guard let imageSelector else { return }
        Task {
            if let data = try? await imageSelector.loadTransferable(type: Data.self),
               let image = UIImage(data: data) {
                selectedImage = image
                changeImage = true
            }
        }
    }

    func updateElements(username: String, password: String) {
        guard validateFields(username: username, password: password) else {
            showInfo(message: "Los datos introducidos no son correctos", info: true, logout: false)
            return
        }

        if !password.isEmpty {
            Auth.auth().currentUser?.updatePassword(to: password) { error in
                if let error {
                    print(error.localizedDescription)
                    self.showInfo(message: "Ha ocurrido un problema actualizando tus datos.", info: false, logout: false)
                } else {
                    self.updateService(username: username, password: password)
                }
            }
        } else {
            updateService(username: username, password: password)
        }
    }

    private func updateService(username: String, password: String) {
        if !username.isEmpty { profileInfo.userName = username }
        if let image = selectedImage, let imageString = image.imageToUInt8ArrayString() {
            profileInfo.profilePicture = imageString
        }

        guard let userInfo = UserDefaults.getUser() else { return }
        let updatedPassword = password.isEmpty ? userInfo.pwd : password
        let userModel = UserModel(
            userID: profileInfo.userId,
            userName: username.isEmpty ? userInfo.userName : username,
            pwd: updatedPassword,
            email: profileInfo.email
        )
        UserDefaults.saveUser(user: userModel)

        let profileRequest = updateProfileRequest(
            userName: profileInfo.userName,
            pwd: password,
            email: profileInfo.email,
            image: profileInfo.profilePicture ?? ""
        )
        mainRepository.updateProfile(profile: profileRequest)
    }

    func showInfo(message: String, info: Bool, logout: Bool) {
        showAlert.toggle()
        self.infoOnly = info
        self.logOut = logout
        self.msg = message
    }

    func signOut() {
        do {
            try Auth.auth().signOut()
            UserDefaults.deleteUser()
            showInfo(message: "Sesión cerrada con éxito.", info: false, logout: true)
        } catch let error as NSError {
            print("Error signing out: %@", error)
        }
    }
}

// MARK: - Validations

extension ProfileVM {
    func validateNewPass(_ text: String) -> String? {
        let passRegex = "^(?=.*\\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[~£€¥$&+,:;=?¿@#|¬_`'\"ºª<>.^*\\[\\]{}()%!¡\\-\\\\/])[a-zA-Z\\d~£€¥$&+,:;=?¿@#|¬_`'\"ºª<>.^*\\[\\]{}()%!¡\\-\\\\/]{8,}$"
        return text.evaluate(regexp: passRegex) ? nil : "is not a valid password"
    }

    func validateNewUsername(_ text: String) -> String? {
        return text.contains(" ") || text.isEmpty || text.count > 25
            ? "must not have spaces, be empty, or longer than 25 characters."
            : nil
    }

    func validateFields(username: String, password: String) -> Bool {
        return (username.isEmpty || validateNewUsername(username) == nil) &&
               (password.isEmpty || validateNewPass(password) == nil)
    }
}

// MARK: - MainMenuAPI Delegate

extension ProfileVM: MainMenuApiDelegate {
    func getUserInfoSucces(model: GetUserAllInfoResult) { }

    func getUserInfoError(error: String) { }

    func updateProfileSucces() {
        showInfo(message: "Información actualizada correctamente.", info: false, logout: false)
        guard let userInfo = UserDefaults.getUser() else { return }
        let updatedUser = UserModel(
            userID: profileInfo.userId,
            userName: profileInfo.userName,
            pwd: userInfo.pwd,
            email: profileInfo.email
        )
        UserDefaults.saveUser(user: updatedUser)
    }

    func updateProfileError(error: String) {
        showInfo(message: error, info: true, logout: false)
    }
}

