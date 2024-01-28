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

    init(progress: CGFloat, totalTime: CGFloat, remainingTimeValue: String) {
        self.progress = progress
        self.totalTime = totalTime
        self.remainingTimeValue = remainingTimeValue
    } 
}
