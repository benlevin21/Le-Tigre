//
//  UserProfileView.swift
//  Cams IPad
//
//  Created by Ben Levin on 3/27/25.
//

import SwiftUI

class UserSettings: ObservableObject {
    @AppStorage("username") var username: String = "Cam Ron"
    @AppStorage("selectedAvatar") var selectedAvatar: String = "🧠"
    @AppStorage("isDarkMode") var isDarkMode: Bool = true
}

struct UserProfileView: View {
    @EnvironmentObject var userSettings: UserSettings
    @Environment(\.colorScheme) var systemColorScheme
    @Environment(\.scenePhase) var scenePhase
    @State private var overrideColorScheme: ColorScheme? = nil

    let availableAvatars = ["🧠", "🐱", "🐉", "🤖", "🧑‍🚀", "🐛", "🧨"]

    var body: some View {
        ZStack {
            (userSettings.isDarkMode ? Color.black : Color.white).ignoresSafeArea()

            VStack(spacing: 25) {
                Text("👤 User Profile")
                    .font(.largeTitle)
                    .foregroundColor(userSettings.isDarkMode ? .white : .black)

                // 👤 Name Input
                TextField("Enter your name", text: $userSettings.username)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                    .foregroundColor(.primary)
                    .padding(.horizontal)

                // 🖼 Avatar Picker
                Text("Choose Your Avatar")
                    .foregroundColor(userSettings.isDarkMode ? .white : .black)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 15) {
                        ForEach(availableAvatars, id: \.self) { avatar in
                            Text(avatar)
                                .font(.system(size: 40))
                                .padding()
                                .background(userSettings.selectedAvatar == avatar ? Color.blue.opacity(0.3) : Color.clear)
                                .cornerRadius(10)
                                .onTapGesture {
                                    userSettings.selectedAvatar = avatar
                                }
                        }
                    }
                    .padding(.horizontal)
                }

                // 🌙 Light/Dark Mode Toggle
                Toggle(isOn: $userSettings.isDarkMode) {
                    Text("Dark Mode")
                        .foregroundColor(userSettings.isDarkMode ? .white : .black)
                }
                .padding(.horizontal)
                .toggleStyle(SwitchToggleStyle(tint: .blue))

                Spacer()
            }
            .preferredColorScheme(userSettings.isDarkMode ? .dark : .light)
            .padding()
        }
    }
}
