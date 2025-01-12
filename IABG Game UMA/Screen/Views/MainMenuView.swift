//
//  MainMenuView.swift
//  IABG Game UMA
//
//  Created by Diego Sánchez on 22/12/24.
//

import SwiftUI
import FirebaseAuth

struct MainMenuView: View {
    @State private var path: [Constants.NavigationDestination] = []
    @State private var resetID = UUID()
    @ObservedObject var mainMenuVM: MainMenuVM
    @State private var levelSelected: levels = .none
    
    var body: some View {
        NavigationStack(path: $path) {
            ZStack {
                if mainMenuVM.isLoading {
                    ProgressView()
                        .toolbar(.hidden)
                } else {
                    VStack(spacing: 0) {
                        HeaderView()
                        
                        ProfileButton(mainMenuVM: mainMenuVM, path: $path)
                            .padding(.top, 35)
                            .padding(.bottom, 30)
                        
                        StatisticsAndRankingButtons(mainMenuVM: mainMenuVM, path: $path)
                            .padding(.horizontal, 40)
                            .padding(.bottom, 15)
                        
                        Spacer()
                        
                        LevelSelectionView(levelSelected: $levelSelected)
                        
                        Spacer()
                        
                        StartGameButton(levelSelected: $levelSelected, path: $path)
                            .padding(16)
                    }
                    .foregroundColor(.black)
                    .background(Color("SecondBlue"))
                    .navigationBarBackButtonHidden()
                    .alert("App Info", isPresented: $mainMenuVM.showAlert) {
                        Button("OK", role: .cancel) { }
                    } message: {
                        Text(mainMenuVM.msg)
                    }
                }
            }
            .onAppear {
                print("Entro en el main")
                handleOnAppear()
            }
            .id(resetID)
            .navigationDestination(for: Constants.NavigationDestination.self) { destination in
                navigationDestinationView(for: destination)
            }
        }
        .onDisappear {
            levelSelected = .none
        }
    }
}

// MARK: - Subviews

struct HeaderView: View {
    var body: some View {
        HStack {
            Spacer()
            Image("iconscreen")
                .resizable()
                .frame(width: 150, height: 60)
            Spacer()
        }
        .padding(.top, 5)
        .background(Color.white)
        .overlay(Rectangle().frame(height: 1).padding(.top, 44).tint(.gray), alignment: .bottom)
    }
}

struct ProfileButton: View {
    @ObservedObject var mainMenuVM: MainMenuVM
    @Binding var path: [Constants.NavigationDestination]
    
    var body: some View {
        Button {
            //arreglar el path
            path.append(.profileView(profile: mainMenuVM.profileModel))
        } label: {
            VStack {
                if let profileImage = mainMenuVM.profileModel.profilePicture?.stringToUInt8ArrayImage() {
                    AvatarView(avatar: profileImage, pending: nil)
                } else {
                    AvatarView(avatar: nil, pending: nil)
                }
                Text("Profile")
                    .fontWeight(.semibold)
                    .font(.system(size: 15))
            }
            .padding(10)
        }
    }
}

struct StatisticsAndRankingButtons: View {
    @ObservedObject var mainMenuVM: MainMenuVM
    @Binding var path: [Constants.NavigationDestination]
    
    var body: some View {
        HStack {
            Button {
                path.append(.statisticsView(statictics: mainMenuVM.staticticsModel))
            } label: {
                StatButtonContent(icon: "chart.line.uptrend.xyaxis", label: NSLocalizedString("Statistics", comment: ""), isImage: true)
            }
            
            Spacer()
            
            Button {
                mainMenuVM.getUser()
            } label: {
                StatButtonContent(icon: "\(mainMenuVM.staticticsModel.ranking)º", label: "Ranking", isImage: false)
            }
        }
    }
}

struct StatButtonContent: View {
    let icon: String
    let label: String
    let isImage: Bool
    
    var body: some View {
        VStack {
            if isImage {
                Image(systemName: icon)
                    .frame(width: 80, height: 50)
                    .background(Color("SecondGreen"))
                    .foregroundColor(.black)
                    .clipShape(Rectangle())
                    .cornerRadius(8)
            } else {
                Text(icon)
                    .padding()
                    .frame(width: 80, height: 50)
                    .background(Color("SecondGreen"))
                    .foregroundColor(.black)
                    .cornerRadius(8)
            }

            Text(label)
                .fontWeight(.semibold)
                .font(.system(size: 15))
        }
    }
}

struct LevelSelectionView: View {
    @Binding var levelSelected: levels
    
    var body: some View {
        VStack {
            Text("Selecciona un nivel para comenzar partida")
            
            ForEach([levels.easy, levels.medium, levels.dificult], id: \.self) { level in
                Button {
                    levelSelected = level
                } label: {
                    HStack {
                        Text(getLevelName(level))
                            .frame(width: 130, height: 30, alignment: .center)
                        Spacer().frame(width: 44)
                        ForEach(0..<3) { index in
                            Image(systemName: index < level.starCount ? "star.fill" : "star")
                                .font(.system(size: 23))
                                .foregroundColor(.yellow)
                                .opacity(index < level.starCount ? 0.75 : 0.5)
                        }
                    }
                }
                .buttonStyle(LevelButton(type: level, isSelected: levelSelected == level))
                .cornerRadius(8)
                .padding(8)
            }
        }
    }
}

struct StartGameButton: View {
    @Binding var levelSelected: levels
    @Binding var path: [Constants.NavigationDestination]
    
    var body: some View {
        Button {
            if levelSelected != .none {
                UserDefaults.setLevel(value: levelSelected.rawValue)
                path.append(Constants.NavigationDestination.gameView)
            }
        } label: {
            Text("Comenzar partida")
        }
        .disabled(levelSelected == .none)
        .buttonStyle(ThirdButton())
    }
}

// MARK: - Helper Methods

extension MainMenuView {
    func handleOnAppear() {
        if UserDefaults.getUser() != nil, Auth.auth().currentUser != nil {
            
            mainMenuVM.isLoading = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.mainMenuVM.getUser()
            }
            self.levelSelected = .none
        } else {
            path.append(Constants.NavigationDestination.loginView)
        }
    }
    
    @ViewBuilder
    func navigationDestinationView(for destination: Constants.NavigationDestination) -> some View {
        switch destination {
        case .registerView:
            RegisterView(path: $path, loginVM: LoginVM(user: UserModel(userID: "", userName: "", pwd: "", email: "")))
        case .forgotView:
            ForgotPassView(loginVM: LoginVM(user: UserModel(userID: "", userName: "", pwd: "", email: "")), path: $path)
        case .loginView:
            LoginView(path: $path, resetID: $resetID, loginVM: LoginVM(user: UserModel(userID: "", userName: "", pwd: "", email: "")))
        case .statisticsView(let statistic):
            StatisticsView(path: $path, statisticsVM: StatisticsVM(staticticsModel: statistic))
        case .profileView(let profile):
            ProfileView(path: $path, profileVM: ProfileVM(profileInfo: profile))
        case .gameView:
            GameView(path: $path)
        case .endGame(let games):
            EndGameView(path: $path, endGameVM: EndGameVM(elements: games))
        }
    }
}

// MARK: - Levels Extension

extension levels {
    var starCount: Int {
        switch self {
        case .easy: return 1
        case .medium: return 2
        case .dificult: return 3
        case .none: return 0
        }
    }
}
