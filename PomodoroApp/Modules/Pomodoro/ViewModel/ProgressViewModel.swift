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
    private var userDefaults = UserDefaultManager.shared
    var currentTimerState: TimerState
    var homeViewModel = HomeViewModel()
    
    init(progress: ProgressModel, currentTask: TaskModel) {
        self.currentTask = currentTask
        self.progressModel = progress
        self.currentTimerState = .notStarted
        self.progressModel.remainingTimeValue = "\(String(Int(progress.totalTime)).stringToTimeString())"
        fetchCurrentTimerState()
    }
    
    func fetchCurrentTimerState() {
        if let currentStateString: String = userDefaults.get(for: .currentTimerState) {
            if let currentState = TimerState(rawValue: currentStateString) {
                self.currentTimerState = currentState
            } else {
                print("Error: cant fetch state ")
            }
        }
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
        changeTimerState(with: .notStarted)
        timer?.invalidate()
        timer = nil
        progressModel.progress = 0
        progressModel.remainingTimeValue = String(Int(progressModel.totalTime)).stringToTimeString()
        
    }
    
    func resumeTimer() {
        startTimer()
        changeTimerState(with: .focusing)
    }
    
    func changeTimerState(with newState: TimerState) {
        switch newState {
        case .focusing:
            currentTimerState = .focusing
            userDefaults.set(TimerState.focusing.rawValue, for: .currentTimerState)
            for task in homeViewModel.allTasks {
                if task.taskId != currentTask.taskId {
                    task.isEnter = false
                }
            }
        case .pause:
            currentTimerState = .pause
            userDefaults.set(TimerState.pause.rawValue, for: .currentTimerState)
        case .notStarted:
            currentTimerState = .notStarted
            userDefaults.set(TimerState.notStarted.rawValue, for: .currentTimerState)
            for task in homeViewModel.allTasks {
                task.isEnter = true
            }
        }
    }
    
    func changeTimerRemaining(with remainingTime: String) {
        let newRemainingSeconds = remainingTime.timeStringToSeconds()
        progressModel.progress = 1 - (Double(newRemainingSeconds) / progressModel.totalTime)
        progressModel.remainingTimeValue = "\(newRemainingSeconds / 60):\(newRemainingSeconds % 60)"
    }
    
    func toggleButton() {
        currentTimerState == .focusing ? stopTimer() : startTimer()
    }
}
