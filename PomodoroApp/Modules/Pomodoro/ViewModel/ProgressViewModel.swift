//
//  ProgressModel,.swift
//  PomodoroApp
//
//  Created by Elif Bilge Parlak on 23.12.2023.
//

import Observation
import SwiftUI

enum TimerState: String {
    case notStarted
    case focusing
    case pause
}

@Observable
final class ProgressViewModel {
    var progressModel: ProgressModel
    var timerState: TimerState? = .notStarted
    
    private var timer: Timer?
    
    init(progress: ProgressModel) {
        self.progressModel = progress
        self.progressModel.remainingTimeValue = "\(String(Int(progress.totalTime)).stringToTimeString())"
    }
    
    func startTimer() {
        if timer == nil {
            changeTimerState(with: .focusing)
            timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
                self.progressModel.progress += 1 / self.progressModel.totalTime
                self.progressModel.remainingTimeValue = "\(self.remainingTime().minutes):\(self.remainingTime().seconds)"
                if self.progressModel.progress >= 1 {
                    self.stopTimer()
                }
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
        progressModel.remainingTimeValue = String(Int(progressModel.totalTime)).stringToTimeString()
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
    
    func changeTimerRemaining(with remainingTime: String) {
        let newRemainingSeconds = remainingTime.timeStringToSeconds()
        
        progressModel.progress = 1 - (Double(newRemainingSeconds) / progressModel.totalTime)
        progressModel.remainingTimeValue = "\(newRemainingSeconds / 60):\(newRemainingSeconds % 60)"
        
        if progressModel.progress > 0 {
            changeTimerState(with: .focusing)
        } else {
            changeTimerState(with: .notStarted)
        }
    }
    
    func fetchTimerState(currentState: String?) {
        switch currentState {
        case TimerState.notStarted.rawValue:
            return changeTimerState(with: .notStarted)
        case TimerState.focusing.rawValue:
            return changeTimerState(with: .focusing)
        case TimerState.pause.rawValue :
            return changeTimerState(with: .pause)
        default:
            return 
        }
    }
}
