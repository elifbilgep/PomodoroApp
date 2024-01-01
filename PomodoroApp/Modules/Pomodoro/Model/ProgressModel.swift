//
//  ProgressModel.swift
//  PomodoroApp
//
//  Created by Elif Bilge Parlak on 26.12.2023.
//

import Foundation


class ProgressModel {
    var progress: CGFloat
    var circleProgress: CGFloat
    var totalTime: CGFloat

    init(progress: CGFloat, circleProgress: CGFloat, totalTime: CGFloat) {
        self.progress = progress
        self.circleProgress = circleProgress
        self.totalTime = totalTime
    }
}
