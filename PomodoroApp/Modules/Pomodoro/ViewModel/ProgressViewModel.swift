//
//  ProgressModel,.swift
//  PomodoroApp
//
//  Created by Elif Bilge Parlak on 23.12.2023.
//

import Foundation
import SwiftUI
import Combine

enum TimerState {
    case notStarted
    case focusing
    case pause
}

final class ProgressViewModel: ObservableObject {
    
    @Published var progressModel: ProgressModel
    @Published var timerState: TimerState? = .notStarted
    @Published private(set) var remainingTimeValue: String
    
    
    private var timer: Timer?
    
    init(progress: ProgressModel) {
        self.progressModel = progress
        self.remainingTimeValue = "\(String(Int(progress.totalTime)).stringToTimeString())"
    }
    
    func startTimer() {
        if timer == nil {
            changeTimerState(with: .focusing)
            timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
                self.progressModel.progress += 1 / self.progressModel.totalTime
                self.remainingTimeValue = "\(self.remainingTime().minutes):\(self.remainingTime().seconds)"
                if self.progressModel.progress >= 1 {
                    self.stopTimer()
                }
                print(self.progressModel.progress)
            }
            RunLoop.current.add(timer!, forMode: .common)
            
        }
    }
    
    func remainingTime() -> (minutes: Int, seconds: Int) {
        let remainingSeconds = Int((1 - self.progressModel.progress) * self.progressModel.totalTime)
        let minutes = remainingSeconds / 60
        let seconds = remainingSeconds % 60
        return (minutes, seconds)
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
        changeTimerState(with: .pause)
    }
    
    func resetTimer() {
        stopTimer()
        progressModel.progress = 0
        remainingTimeValue = String(Int(progressModel.totalTime)).stringToTimeString()
        changeTimerState(with: .notStarted)
    }
    
    func togglePauseandResume() {
        if timerState == .focusing {
            stopTimer()
            changeTimerState(with: .pause)
        } else if timerState == .notStarted || timerState == .pause  {
            startTimer()
            changeTimerState(with: .focusing)
        }
    }
    
    func changeTimerState(with newState: TimerState) {
        switch newState {
        case .notStarted:
            self.timerState = .notStarted
        case .focusing:
            self.timerState = .focusing
        case .pause:
            self.timerState = .pause
        }
    }
}
