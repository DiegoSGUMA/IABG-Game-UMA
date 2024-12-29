//
//  ProfileView.swift
//  IABG Game UMA
//
//  Created by Diego Sánchez on 28/12/24.
//

import SwiftUI
import PhotosUI

struct ProfileView: View {
    @Binding var path: [Constants.NavigationDestination]
    @ObservedObject var profileVM: ProfileVM
    @State private var changeImage = false
    @State private var userName = ""
    @State private var pass = ""
    @State private var changePassword = false
    @State private var changeUsername = false

    var body: some View {
        if profileVM.isLoading {
            ProgressView()
        } else {
            VStack {
                headerBar
                ScrollView {
                    profileImageSection
                    profileDetailsSection
                }
                .scrollDisabled(!(changePassword || changeUsername || profileVM.changeImage))
                Spacer()
                actionButtons
            }
            .background(Color("SecondBlue"))
            .navigationBarBackButtonHidden()
            .alert("App Warning", isPresented: $profileVM.showAlert) {
                alertActions
            } message: {
                Text(profileVM.msg)
            }
        }
    }

    private var headerBar: some View {
        HeaderBar(title: NSLocalizedString("Profile", comment: "")) {
            path.removeLast()
        }
    }

    private var profileImageSection: some View {
        VStack {
            Button {
                // Logic for image change can be added here
            } label: {
                VStack {
                    let imageName = profileVM.profileInfo.profilePicture ?? ""
                    if let convertedImage = imageName.stringToUInt8ArrayImage(), !imageName.isEmpty {
                        AvatarView(avatar: convertedImage, pending: profileVM.selectedImage)
                            .padding(10)
                    } else {
                        AvatarView(avatar: nil, pending: profileVM.selectedImage)
                            .padding(10)
                    }

                    PhotosPicker(selection: $profileVM.imageSelector,
                                 matching: .images,
                                 photoLibrary: .shared()) {
                        Text("Cambiar imagen")
                            .foregroundColor(Color("FirstGreen"))
                    }
                    .buttonStyle(.borderless)
                }
                .padding(30)
            }
        }
    }

    private var profileDetailsSection: some View {
        //ARREGlar la validación
        VStack(alignment: .leading) {
            detailRow(label: "Email", value: profileVM.profileInfo.email)
            editableFieldRow(
                label: "Password",
                isEditing: $changePassword,
                currentValue: profileVM.profileInfo.passwordCount == 0
                    ? "***********"
                    : String(repeating: "*", count: profileVM.profileInfo.passwordCount),
                textFieldBinding: $pass,
                validation: Validations.validatePass,
                isSecure: true
            )
            editableFieldRow(
                label: "Username",
                isEditing: $changeUsername,
                currentValue: profileVM.profileInfo.userName,
                textFieldBinding: $userName,
                validation: Validations.validateUsername,
                isSecure: false
            )
            progressBarSection
        }
        .padding(.horizontal, 16)
    }

    private var actionButtons: some View {
        VStack {
            Button {
               // profileVM.updateElements(username: userName, password: pass)
            } label: {
                Text("Save")
            }
            .disabled(!(changePassword || changeUsername || profileVM.changeImage))
            .buttonStyle(SecondaryButton())
            .padding(16)

            Button {
             //   profileVM.singOut()
            } label: {
                Text("Log out")
            }
            .buttonStyle(MainButton())
            .padding(.horizontal, 16)
            .padding(.bottom, 26)
        }
    }

    private var progressBarSection: some View {
        VStack {
            HStack {
                Spacer()
                Text("\(NSLocalizedString("Attention_level", comment: "")): \(String(format: "%.2f", profileVM.profileInfo.percentajeLevel / 10))")
                Spacer()
            }
            ProgressView(value: profileVM.profileInfo.percentajeLevel / 10)
                .background(LinearGradient(gradient: Gradient(colors: [.red, .yellow, .green]), startPoint: .leading, endPoint: .trailing))
                .tint(.gray)
                .padding(.horizontal, 30)
        }
        .padding(.vertical, 7)
    }

    private var alertActions: some View {
        Button {
            if !profileVM.infoOnly, !profileVM.logOut {
                path.removeAll()
            } else if profileVM.logOut {
                path.append(Constants.NavigationDestination.loginViow)
            }
        } label: {
            Text(profileVM.infoOnly ? "OK" : "Ir al menu principal")
        }
    }

    private func detailRow(label: String, value: String) -> some View {
        VStack(alignment: .leading) {
            Text(label).bold()
            Text(value)
        }
        .padding(.vertical, 10)
    }

    private func editableFieldRow(
        label: String,
        isEditing: Binding<Bool>,
        currentValue: String,
        textFieldBinding: Binding<String>,
        validation: @escaping (String, String?) -> String?,
        isSecure: Bool
    ) -> some View {
        HStack {
            if isEditing.wrappedValue {
                
                FieldText(label: NSLocalizedString(label, comment: ""),
                          text: textFieldBinding,
                          secondPass: textFieldBinding,
                          validation: validation,
                          isPassword: isSecure)
                .textContentType(isSecure ? .password : .username)
                .autocorrectionDisabled()
                .textInputAutocapitalization(isSecure ? .never : .characters)
                
            } else {
                VStack(alignment: .leading) {
                    Text(label).bold()
                    Text(currentValue)
                }
            }
            Spacer()
            Button {
                if isEditing.wrappedValue {
                    textFieldBinding.wrappedValue = ""
                }
                isEditing.wrappedValue.toggle()
            } label: {
                Image(systemName: isEditing.wrappedValue ? "x.circle" : "rectangle.and.pencil.and.ellipsis")
                    .foregroundColor(isEditing.wrappedValue ? .gray : Color("FirstGreen"))
            }
            .padding(.horizontal)
        }
        .padding(.vertical, 10)
    }
}

#Preview {
    NavigationStack {
        ProfileView(
            path: .constant([Constants.NavigationDestination]()),
            profileVM: ProfileVM(profileInfo: ProfileModel(userId: "",
                                                           userName: "Prueba",
                                                           email: "prueba@gmail.com",
                                                           profilePicture: nil,
                                                           passwordCount: 6,
                                                           percentajeLevel: 0))
        )
    }
}
