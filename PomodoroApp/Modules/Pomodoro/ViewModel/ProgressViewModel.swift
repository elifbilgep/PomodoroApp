//
//  ProgressModel,.swift
//  PomodoroApp
//
//  Created by Elif Bilge Parlak on 23.12.2023.
//

import Foundation
import SwiftUI

class ProgressViewModel: ObservableObject {

    @Published var progress: CGFloat?
    @Published var circleProgress: CGFloat?

    var timer: Timer?
    var progressModel: ProgressModel
    var isTimerRunning: Bool = false


    init(progress: ProgressModel) {
        self.progressModel = progress
    }

    func startTimer() {
        if timer == nil {
            timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
                self.progressModel.progress += 1 / self.progressModel.totalTime
                self.circleProgress = self.progress // progress ile aynı hızda ilerlesin
                if self.progressModel.progress >= 1 {
                    self.stopTimer()
                }
            }
            RunLoop.current.add(timer!, forMode: .common)
            isTimerRunning = true
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
        isTimerRunning = false
    }

    func pauseOrResumeTimer() {
        if isTimerRunning {
            stopTimer()
        } else {
            startTimer()
        }
    }


}
