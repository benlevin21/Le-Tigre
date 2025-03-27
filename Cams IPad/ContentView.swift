import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var streakManager: StreakManager
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                
                // 🏯 CUSTOM DOJO TITLE WITH GLOW
                Text("🏯 Cam's Coding Dojo")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundStyle(
                        LinearGradient(colors: [.cyan, .indigo], startPoint: .topLeading, endPoint: .bottomTrailing)
                    )
                    .shadow(color: .indigo.opacity(0.5), radius: 5, x: 0, y: 2)
                    .multilineTextAlignment(.center)
                    .padding(.top)
                
                Image(systemName: "face.smiling")
                    .imageScale(.large)
                    .foregroundStyle(.tint)
                
                Text("Hello, Cam Ron")
                    .font(.title2)
                    .bold()
                
                // 🔥 STREAK BANNER
                Text("🔥 Daily Streak: \(streakManager.streakCount) day\(streakManager.streakCount == 1 ? "" : "s")")
                    .font(.title)
                    .foregroundColor(.yellow)

                // 🎮 GAME & NAVIGATION BUTTONS
                Group {
                    NavigationLink(destination: MatchGameView()) {
                        Text("🧠 SWIFT DOJO: Test Your Coding")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, minHeight: 50)
                            .background(Color.blue)
                            .cornerRadius(10)
                    }

                    NavigationLink(destination: CatchTheBugView()) {
                        Text("🐛 Catch The Bug")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, minHeight: 50)
                            .background(Color.red)
                            .cornerRadius(10)
                    }

                    NavigationLink(destination: EnumEliminatorView()) {
                        Text("🧨 Eliminate the Enums")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, minHeight: 50)
                            .background(Color.purple)
                            .cornerRadius(10)
                    }

                    NavigationLink(destination: AccomplishmentsView()) {
                        Text("🏅 View Your Accomplishments")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, minHeight: 50)
                            .background(Color.orange)
                            .cornerRadius(10)
                    }

                    NavigationLink(destination: UserProfileView()) {
                        Text("👤 Profile")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, minHeight: 50)
                            .background(Color.gray)
                            .cornerRadius(10)
                    }
                }
                .padding(.horizontal)
            }
            .padding()
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(StreakManager())
        .environmentObject(UserSettings())
}
