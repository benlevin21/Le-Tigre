//
//  Cams_IPadApp.swift
//  Cams IPad
//
//  Created by Ben Levin on 3/24/25.
//

import SwiftUI

@main
struct Cams_IPadApp: App {
    @StateObject var streakManager = StreakManager()
    @StateObject var userSettings = UserSettings()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(streakManager)
                .environmentObject(userSettings)
        }
    }
}

//animated bug movement for game 
struct AnimatedBugRow: View {
    @State private var xOffset: CGFloat = -150

    var body: some View {
        ZStack(alignment: .leading) {
            Text("🐛")
                .font(.title)
                .offset(x: xOffset)
                .animation(.linear(duration: 3).repeatForever(autoreverses: false), value: xOffset)
        }
        .frame(width: 300, height: 30)
        .clipped()
        .onAppear {
            xOffset = 150
        }
    }
}

