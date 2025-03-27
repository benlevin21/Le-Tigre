//
//  Enum_Eliminator.swift
//  Cams IPad
//
//  Created by Ben Levin on 3/26/25.
//

import SwiftUI

struct EnumQuestion: Identifiable {
    let id = UUID()
    let prompt: String
    let code: String
    let options: [String]
    let correctAnswer: String
}
struct ExplosionEffect: View {
    @State private var explode = false
    
    Text("💥")
        .font(.system(size: 50))
        .scaleEffect(explode ? 1.5 : 0.8)
        .opacity(explode ? 0.6 : 1)
        .rotationEffect(.degrees(explode ? 15 : -15))
        .animation(
            Animation.easeInOut(duration: 0.6)
                .repeatForever(autoreverses: true),
            value: explode
        )
        .onAppear {
            explode = true
        }
}
}

struct EnumEliminatorView: View {
    @EnvironmentObject var streakManager: StreakManager

    @State private var enumQuestions: [EnumQuestion] = [
        EnumQuestion(
            prompt: "Which enum case is used to represent a failed result?",
            code: """
enum Result {
    case success(String)
    case failure(String)
}
""",
            options: ["success", "failure", "cancel", "error"],
            correctAnswer: "failure"
        ),
        EnumQuestion(
            prompt: "What is wrong with this enum declaration?",
            code: """
enum Direction {
    case north
    case south
    case east
    case westward
    case up down
}
""",
            options: [
                "You can't put two words in one case name",
                "Enums can't have more than 4 cases",
                "Missing enum keyword",
                "Enums must start with capital letters"
            ],
            correctAnswer: "You can't put two words in one case name"
        ),
        EnumQuestion(
            prompt: "Which is a valid way to associate data with an enum case?",
            code: """
enum NetworkResponse {
    case success(data: String)
    case error(message: String)
}
""",
            options: [
                "case failed[String]",
                "case loading",
                "case success(data: String)",
                "case .error = String"
            ],
            correctAnswer: "case success(data: String)"
        )
    ]

    @State private var currentIndex = 0
    @State private var selectedAnswer: String?
    @State private var showResult = false
    @State private var correctCount = 0
    @State private var wrongCount = 0
    @State private var animateCorrect = false
    @State private var animateWrong = false

    var body: some View{
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: 20) {
                Text("🧨 Enum Eliminator")
                    .font(.title)
                    .bold()
                    .foregroundColor(.orange)

                Text("Destroy incorrect enum knowledge. Only clean code survives.")
                    .font(.caption)
                    .foregroundColor(.gray)

                Text("🔥 Daily Streak: \(streakManager.streakCount) day\(streakManager.streakCount == 1 ? "" : "s")")
                    .font(.subheadline)
                    .foregroundColor(.yellow)

                ProgressView(value: Double(currentIndex), total: Double(enumQuestions.count))
                    .progressViewStyle(LinearProgressViewStyle(tint: .orange))
                    .scaleEffect(x: 1, y: 2, anchor: .center)
                    .padding(.horizontal)

                Spacer()

                if currentIndex < enumQuestions.count {
                    let question = enumQuestions[currentIndex]

                    Text(question.prompt)
                        .foregroundColor(.white)
                        .font(.headline)

                    Text(question.code)
                        .font(.system(.body, design: .monospaced))
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10)

                    ForEach(question.options, id: \.self) { option in
                        let isCorrectSelection = showResult && selectedAnswer == option && option == question.correctAnswer
                        let isWrongSelection = showResult && selectedAnswer == option && option != question.correctAnswer

                        Button {
                            selectedAnswer = option
                            checkAnswer()
                        } label: {
                            Text(option)
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.blue.opacity(0.3))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(
                                            isCorrectSelection ? Color.green :
                                            isWrongSelection ? Color.red : Color.clear,
                                            lineWidth: 3
                                        )
                                        .shadow(color: isWrongSelection ? Color.red : .clear, radius: 10)
                                )
                                .cornerRadius(8)
                                .scaleEffect(isCorrectSelection ? 1.05 : 1.0)
                                .offset(x: isWrongSelection && animateWrong ? -6 : 0)
                                .animation(
                                    isWrongSelection && animateWrong ?
                                    Animation.default.repeatCount(3, autoreverses: true) : .default,
                                    value: animateWrong
                                )
                        }
                    }
                } else {
                    Text("🎉 You eliminated all the bad enums!")
                        .foregroundColor(.green)
                        .font(.headline)

                    Text("Score: \(correctCount) ✅  |  \(wrongCount) ❌")
                        .foregroundColor(.white)
                }

                Spacer()

                if showResult {
                    Text(resultText())
                        .font(.headline)
                        .foregroundColor(resultColor())
                        .scaleEffect(animateCorrect ? 1.4 : 1)
                        .animation(.easeInOut(duration: 0.3), value: animateCorrect)
                }

                if showResult && selectedAnswer != enumQuestions[currentIndex].correctAnswer {
                    Button("Next") {
                        nextQuestion()
                    }
                    .padding()
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(8)
                    .foregroundColor(.white)
                }

                HStack(spacing: 40) {
                    Label("\(correctCount)", systemImage: "checkmark.circle.fill")
                        .foregroundColor(.green)
                    Label("\(wrongCount)", systemImage: "xmark.circle.fill")
                        .foregroundColor(.red)
                }
                .font(.title2)
            }
            .padding()
        }
    }

    func checkAnswer() {
        guard let selected = selectedAnswer else { return }
        let correct = enumQuestions[currentIndex].correctAnswer

        showResult = true
        animateCorrect = true

        if selected == correct {
            correctCount += 1

            if currentIndex == enumQuestions.count - 1 {
                streakManager.updateStreakIfNeeded()
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 1.3) {
                animateCorrect = false
                nextQuestion()
            }
        } else {
            wrongCount += 1
            animateWrong = true

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                animateWrong = false
            }
        }
    }

    func nextQuestion() {
        currentIndex += 1
        selectedAnswer = nil
        showResult = false
    }

    func resultText() -> String {
        guard let selected = selectedAnswer else { return "" }
        let isCorrect = selected == enumQuestions[currentIndex].correctAnswer
        return isCorrect ? "💥 Eliminated!" : "❌ Incorrect... Try again, Dev-senpai"
    }

    func resultColor() -> Color {
        guard let selected = selectedAnswer else { return .white }
        return selected == enumQuestions[currentIndex].correctAnswer ? .green : .red
    }
}
