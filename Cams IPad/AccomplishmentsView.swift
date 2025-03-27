//
//  AccomplishmentsView.swift
//  Cams IPad
//
//  Created by Ben Levin on 3/27/25.
//

import Foundation

struct Trophy: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let icon: String  // Emoji or SF Symbol
    let isUnlocked: Bool
}

import SwiftUI

struct AccomplishmentsView: View {
    @State private var trophies: [Trophy] = [
        Trophy(title: "Swift Starter", description: "Completed first code match", icon: "🧠", isUnlocked: true),
        Trophy(title: "Bug Smasher", description: "Beat Catch The Bug", icon: "🐞", isUnlocked: true),
        Trophy(title: "Enum Eliminator", description: "Finished all enum challenges", icon: "🧨", isUnlocked: true),
        Trophy(title: "Streak Seeker", description: "3-day streak!", icon: "🔥", isUnlocked: false),
        Trophy(title: "Perfect Round", description: "Got 100% on a quiz", icon: "🥇", isUnlocked: false)
    ]

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: 20) {
                Text("🏆 Accomplishments")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.yellow)

                ScrollView {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                        ForEach(trophies) { trophy in
                            VStack {
                                Text(trophy.icon)
                                    .font(.system(size: 50))
                                    .padding()
                                    .background(trophy.isUnlocked ? Color.green.opacity(0.3) : Color.gray.opacity(0.2))
                                    .clipShape(Circle())
                                    .overlay(
                                        Circle()
                                            .stroke(trophy.isUnlocked ? Color.green : Color.gray, lineWidth: 3)
                                    )

                                Text(trophy.title)
                                    .foregroundColor(.white)
                                    .font(.headline)

                                Text(trophy.description)
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                    .multilineTextAlignment(.center)
                            }
                            .padding()
                            .background(Color.white.opacity(0.05))
                            .cornerRadius(12)
                            .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 2)
                        }
                    }
                    .padding()
                }
            }
        }
    }
}
