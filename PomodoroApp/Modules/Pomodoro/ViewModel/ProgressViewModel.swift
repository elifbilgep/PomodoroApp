//
//  ProgressModel,.swift
//  PomodoroApp
//
//  Created by Elif Bilge Parlak on 23.12.2023.
//

import Observation
import SwiftUI

@Observable
final class ProgressViewModel {
    var progressModel: ProgressModel
    private(set) var currentTask: TaskModel
    private(set) var timer: Timer?
    
    init(progress: ProgressModel, currentTask: TaskModel) {
        self.currentTask = currentTask
        self.progressModel = progress
        self.progressModel.remainingTimeValue = "\(String(Int(progress.totalTime)).stringToTimeString())"
    }
    
    func startTimer() {
        if timer == nil {
            timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
                self.progressModel.progress += 1 / self.progressModel.totalTime
                self.progressModel.remainingTimeValue = "\(self.remainingTime().minutes):\(self.remainingTime().seconds)"
                if self.progressModel.progress >= 1 {
                    self.stopTimer()
                    self.changeTimerState(with: .notStarted)
                    self.currentTask.activeSession += 1
                }
            }
            changeTimerState(with: .focusing)
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
        progressModel.remainingTimeValue = String(Int(progressModel.totalTime)).stringToTimeString()
        changeTimerState(with: .pause)
    }
    
    func resumeTimer() {
        startTimer()
        changeTimerState(with: .focusing)
    }
    
    func changeTimerState(with newState: TimerState) {
        switch newState {
        case .focusing:
            progressModel.timerState = .focusing
        case .pause:
            progressModel.timerState = .pause
        case .notStarted:
            progressModel.timerState = .notStarted
        }
    }
    
    func changeTimerRemaining(with remainingTime: String) {
        let newRemainingSeconds = remainingTime.timeStringToSeconds()
        progressModel.progress = 1 - (Double(newRemainingSeconds) / progressModel.totalTime)
        progressModel.remainingTimeValue = "\(newRemainingSeconds / 60):\(newRemainingSeconds % 60)"
    }
    
    func fetchTimerState(currentState: String?) {
        switch currentState {
        case TimerState.focusing.rawValue:
            return changeTimerState(with: .focusing)
        case TimerState.pause.rawValue :
            return changeTimerState(with: .pause)
        default:
            return 
        }
    }
    
    func toggleButton() {
        if progressModel.timerState == .focusing {
            stopTimer()
        } else {
            startTimer()
        }
    }
    
    
}
