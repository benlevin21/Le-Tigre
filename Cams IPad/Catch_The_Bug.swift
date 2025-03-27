//
//  Catch_The_Bug.swift
//  Cams IPad
//
//  Created by Ben Levin on 3/25/25.
//

import SwiftUI

struct BugQuestion: Identifiable {
    let id = UUID()
    let code: String
    let options: [String]
    let correctAnswer: String
}

struct CatchTheBugView: View {
    @EnvironmentObject var streakManager: StreakManager
    
    @State private var bugQuestions: [BugQuestion] = [
        BugQuestion(
            code: """
            let age = "25"
            print(age + 5)
            """,
            options: [
                "Type mismatch (String + Int)",
                "Missing semicolon",
                "Function not defined"
            ],
            correctAnswer: "Type mismatch (String + Int)"
        ),
        BugQuestion(
            code: """
            func greet(name: String) {
                print("Hello, " + name)
            }
            greet()
            """,
            options: [
                "Missing argument for 'name'",
                "Wrong return type",
                "String interpolation error"
            ],
            correctAnswer: "Missing argument for 'name'"
        ),
        BugQuestion(
            code: """
            var isLoggedIn = false
            if isLoggedin {
                print("Welcome back")
            }
            """,
            options: [
                "Typo in variable name 'isLoggedIn'",
                "Incorrect loop syntax",
                "Function called incorrectly"
            ],
            correctAnswer: "Typo in variable name 'isLoggedIn'"
        ),
        BugQuestion(
            code: """
            let items = ["apple", "banana", "cherry"]
            print(items[3])
            """,
            options: [
                "Index out of range",
                "Array not declared properly",
                "Syntax error in print"
            ],
            correctAnswer: "Index out of range"
        )
    ]
    
    @State private var currentQuestionIndex = 0
    @State private var selectedAnswer: String?
    @State private var showResult = false
    @State private var correctCount = 0
    @State private var wrongCount = 0
    @State private var animateCorrect = false
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 20) {
                Text("Catch The Bug!")
                    .font(.title)
                    .bold()
                    .foregroundColor(.red)
                
                Text("Spot the bug in the Swift code. Don't let the bugs sneak past Dev-Sensei!")
                    .font(.caption)
                    .foregroundColor(.gray)
                
                Spacer()
                
                // BUG CRAWLING ANIMATION
                AnimatedBugRow()
                
                // PROGRESS BAR
                ProgressView(value: Double(currentQuestionIndex), total: Double(bugQuestions.count))
                    .progressViewStyle(LinearProgressViewStyle(tint: .green))
                    .scaleEffect(x: 1, y: 2, anchor: .center)
                    .padding(.horizontal)
                
                if currentQuestionIndex < bugQuestions.count {
                    let question = bugQuestions[currentQuestionIndex]
                    
                    Text(question.code)
                        .font(.system(.body, design: .monospaced))
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.gray.opacity(0.2))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(animateCorrect ? Color.green : Color.clear, lineWidth: 3)
                                        .animation(.easeInOut(duration: 0.3), value: animateCorrect)
                                )
                        )
                    
                    ForEach(question.options, id: \.self) { option in
                        Button(action: {
                            selectedAnswer = option
                            checkAnswer()
                        }) {
                            Text(option)
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.blue.opacity(0.3))
                                .cornerRadius(8)
                        }
                    }
                } else {
                    Text("🎉 You got all of the bugs!")
                        .foregroundColor(.green)
                        .font(.headline)
                    
                    Text("Final Score: \(correctCount) ✅  |  \(wrongCount) ❌")
                        .foregroundColor(.white)
                }
                
                Spacer()
                
                if showResult {
                    Text(resultText())
                        .font(.headline)
                        .foregroundColor(resultColor())
                        .scaleEffect(animateCorrect ? 1.5 : 1)
                        .animation(.interpolatingSpring(stiffness: 170, damping: 5), value: animateCorrect)
                }
                
                // Only show "Next" button if answer was wrong
                if showResult && selectedAnswer != bugQuestions[currentQuestionIndex].correctAnswer {
                    Button("Next") {
                        currentQuestionIndex += 1
                        selectedAnswer = nil
                        showResult = false
                    }
                    .padding()
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(8)
                    .foregroundColor(.white)
                }
                
                HStack(spacing: 40) {
                    Label("\(correctCount)", systemImage: "checkmark.circle.fill")
                        .foregroundColor(.green)
                        .font(.title)
                    Label("\(wrongCount)", systemImage: "xmark.circle.fill")
                        .foregroundColor(.red)
                        .font(.title)
                }
                .font(.title2)
                .padding(.bottom)
            }
            .padding()
        }
    }
    
    func checkAnswer() {
        guard let selected = selectedAnswer else { return }
        let question = bugQuestions[currentQuestionIndex]
        
        if selected == question.correctAnswer {
            correctCount += 1
            showResult = true
            animateCorrect = true
            
            // Update streak if this is the last question
            if currentQuestionIndex == bugQuestions.count - 1 {
                streakManager.updateStreakIfNeeded()
            }
            
            // Auto-advance after animation
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                animateCorrect = false
                currentQuestionIndex += 1
                selectedAnswer = nil
                showResult = false
            }
            
        } else {
            wrongCount += 1
            showResult = true
            // Waits for user to tap "Next" manually
        }
    }
    
    func resultText() -> String {
        guard let selected = selectedAnswer else { return "" }
        let isCorrect = selected == bugQuestions[currentQuestionIndex].correctAnswer
        return isCorrect ? "🔥 You caught it!" : "💀 Missed it! The bug got away..."
    }
    
    func resultColor() -> Color {
        guard let selected = selectedAnswer else { return .white }
        return selected == bugQuestions[currentQuestionIndex].correctAnswer ? .green : .red
    }
}
