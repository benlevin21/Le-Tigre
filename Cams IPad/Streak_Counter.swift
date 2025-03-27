//
//  Streak_Counter.swift
//  Cams IPad
//
//  Created by Ben Levin on 3/26/25.
//

import SwiftUI

class StreakManager: ObservableObject {
    @Published var streakCount: Int = 0
    @Published var lastCompletedDate: Date? = nil

    private let streakKey = "streakCount"
    private let dateKey = "lastCompletedDate"
    
    init() {
        loadStreak()
    }
    
    func loadStreak() {
        let defaults = UserDefaults.standard
        streakCount = defaults.integer(forKey: streakKey)
        lastCompletedDate = defaults.object(forKey: dateKey) as? Date
    }

    func updateStreakIfNeeded() {
        let defaults = UserDefaults.standard
        let today = Calendar.current.startOfDay(for: Date())
        
        if let last = lastCompletedDate {
            let diff = Calendar.current.dateComponents([.day], from: Calendar.current.startOfDay(for: last), to: today).day ?? 0
            
            if diff == 1 {
                streakCount += 1
            } else if diff > 1 {
                streakCount = 1
            } // if diff == 0, do nothing (already counted today)
        } else {
            streakCount = 1
        }

        lastCompletedDate = today
        defaults.set(streakCount, forKey: streakKey)
        defaults.set(today, forKey: dateKey)
    }
}
