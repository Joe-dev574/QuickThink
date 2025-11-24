//
//  CountDownModel.swift
//  QuickThink
//
//  Created by Joseph DeWeese on 11/24/25.
//

import SwiftUI
import Combine

class CountDownModel: ObservableObject {
    @Published var timerValue: String = "3"
    @Published var selectedTime: Int = 3
    
    private var startTimer: Timer?
    
    init() {
        self.startCDTimer()
        self.timerValue = "3"
    }
    
    func startCDTimer() {
        startTimer?.invalidate()
        startTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [self] _ in
            if self.selectedTime == 0 {
                self.startTimer?.invalidate()
            } else {
                self.timerValue = "\(selectedTime)"
                self.selectedTime -= 1
            }
        }
    }
    }
//MARK: - Int+Extension
extension Int {
    var asTimestamp: String {
        let hour = self / 3600
        let minute = self / 60 % 60
        let second = self % 60

        return String(format: "%02i:%02i:%02i", hour, minute, second)
    }
}

extension Int {
    var asTimestampD: String {
        let hour = self / 3600
        let minute = self / 60 % 60
        let second = self % 60

        return String(format: "%02i%02i%02i", hour, minute, second)
    }
}


extension Int {
    var asTimesHour: String {
        let hour = self / 3600

        return String(format: "%02i", hour)
    }
}

extension Int {
    var asTimesMinute: String {
        let minute = self / 60 % 60

        return String(format: "%02i", minute)
    }
}

extension Int {
    var asTimesSecond: String {
        let second = self % 60

        return String(format: "%02i", second)
    }
}

extension Int {
    var asTimesHourNo0: String {
        let hour = self / 3600

        return String(format: "%2i", hour)
    }
}

extension Int {
    var asTimesMinuteNo0: String {
        let minute = self / 60 % 60

        return String(format: "%2i", minute)
    }
}


