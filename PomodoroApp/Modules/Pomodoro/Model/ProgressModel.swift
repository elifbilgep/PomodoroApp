//
//  ProgressModel.swift
//  PomodoroApp
//
//  Created by Elif Bilge Parlak on 26.12.2023.
//

import Foundation
import Observation

@Observable
class ProgressModel {
    var progress: CGFloat
    var totalTime: CGFloat
    var remainingTimeValue: String
    var timerState: TimerState

    init(progress: CGFloat, totalTime: CGFloat, remainingTimeValue: String, timerState: TimerState) {
        self.progress = progress
        self.totalTime = totalTime
        self.remainingTimeValue = remainingTimeValue
        self.timerState = timerState
    }
}
