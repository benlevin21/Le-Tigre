//
//  Coding_Game.swift
//  Cams IPad
//
//  Created by Ben Levin on 3/24/25.
//
import SwiftUI

struct CodeMatch: Identifiable, Hashable {
    let id = UUID()
    let code: String
    let description: String
}

struct FloatingBrainView: View {
    @State private var floatUp = false

    var body: some View {
        Text("🧠")
            .font(.system(size: 40))
            .offset(y: floatUp ? -10 : 10)
            .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: floatUp)
            .onAppear { floatUp = true }
    }
}

struct MatchGameView: View {
    @State private var allMatches: [CodeMatch] = [
        CodeMatch(code: "var name = \"Ben\"", description: "Declare a variable with a string"),
        CodeMatch(code: "let age = 25", description: "Declare a constant with a number"),
        CodeMatch(code: "if age > 18 { print(\"Adult\") }", description: "Conditional check for age"),
        CodeMatch(code: "func greet() { print(\"Hello\") }", description: "Define a simple function"),
        CodeMatch(code: "for i in 1...5 { print(i) }", description: "Loop from 1 to 5"),
        CodeMatch(code: "struct Person { var name: String }", description: "Create a struct with a property"),
        CodeMatch(code: "let numbers = [1, 2, 3]", description: "Create an array of numbers"),
        CodeMatch(code: "let isLoggedIn = true", description: "Create a boolean constant"),
        CodeMatch(code: "enum Direction { case up, down }", description: "Define an enum"),
        CodeMatch(code: "var count = 0; count += 1", description: "Increment a variable by 1"),
        CodeMatch(code: "print(\"Hello \\(name)\")", description: "Use string interpolation")
    ]
    
    @State private var selectedCode: CodeMatch?
    @State private var feedback: String?
    @State private var correctCount = 0
    @State private var wrongCount = 0
    @State private var matchedItems: Set<UUID> = []
    @State private var shuffledAnswers: [CodeMatch] = []
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 20) {
                FloatingBrainView()

                Text("🧠 Match the Code!")
                    .font(.title)
                    .foregroundColor(.green)

                // ✅ Full list of code snippets (questions)
                ScrollView {
                    VStack(spacing: 10) {
                        ForEach(allMatches, id: \.id) { snippet in
                            Button {
                                selectedCode = snippet
                                feedback = nil
                            } label: {
                                Text(snippet.code)
                                    .font(.system(.body, design: .monospaced))
                                    .padding()
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .background(selectedCode?.id == snippet.id ? Color.green.opacity(0.4) : Color.gray.opacity(0.2))
                                    .cornerRadius(10)
                                    .foregroundColor(.white)
                            }
                            .disabled(matchedItems.contains(snippet.id)) // Optional: disable matched
                        }
                    }
                    .padding()
                }
                .frame(height: 220)
                .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray.opacity(0.2)))
                .padding(.horizontal)

                // ✅ Full list of answers
                ScrollView {
                    VStack(spacing: 10) {
                        ForEach(shuffledAnswers, id: \.id) { option in
                            Button {
                                handleMatch(with: option)
                            } label: {
                                Text(option.description)
                                    .padding()
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .background(Color.blue.opacity(0.3))
                                    .cornerRadius(10)
                                    .foregroundColor(.white)
                            }
                            .disabled(matchedItems.contains(option.id)) // Optional: disable matched
                        }
                    }
                    .padding()
                }
                .frame(height: 220)
                .background(RoundedRectangle(cornerRadius: 10).fill(Color.blue.opacity(0.2)))
                .padding(.horizontal)

                // Feedback
                if let result = feedback {
                    Text(result)
                        .foregroundColor(result.contains("Correct") ? .green : .red)
                        .font(.headline)
                }

                // Score display
                HStack(spacing: 40) {
                    Label("\(correctCount)", systemImage: "checkmark.seal.fill")
                        .foregroundColor(.green)
                    Label("\(wrongCount)", systemImage: "xmark.seal.fill")
                        .foregroundColor(.red)
                }
                .font(.title2)
            }
            .padding()
        }
        .onAppear {
            shuffledAnswers = allMatches.shuffled()
        }
    }

    func handleMatch(with option: CodeMatch) {
        guard let selected = selectedCode else { return }

        if selected.description == option.description {
            feedback = "✅ Correct!"
            correctCount += 1
            matchedItems.insert(selected.id)
        } else {
            feedback = "❌ Wrong match"
            wrongCount += 1
        }

        selectedCode = nil
    }
}
