//
//  ProgressModel,.swift
//  PomodoroApp
//
//  Created by Elif Bilge Parlak on 23.12.2023.
//

import Foundation
import SwiftUI

class ProgressViewModel: ObservableObject {
    
    @Published var remainingTimeString: String?
    @Published var remainingTimeSeconds: Int?
    @Published var progressModel: ProgressModel
    
    var timer: DispatchSourceTimer?
    var isTimerRunning: Bool = false
    var backgroundProgress: CGFloat?
    var backgroundDate: Date = Date()
    
    init(progress: ProgressModel) {
        self.progressModel = progress
    }
    
    func startTimer() {
            if timer == nil {
                timer = DispatchSource.makeTimerSource(queue: DispatchQueue.main)
                timer?.schedule(deadline: .now(), repeating: 1.0)
                timer?.setEventHandler { [weak self] in
                    guard let self = self else { return }
                    self.progressModel.progress += 1 / self.progressModel.totalTime
                    if self.progressModel.progress >= 1 {
                        self.stopTimer()
                    }
                    // Update remaining time here
                    let remainingTime = Int((1 - self.progressModel.progress) * self.progressModel.totalTime)
                    let remainingMinutes = remainingTime / 60
                    let remainingSeconds = remainingTime % 60
                    DispatchQueue.main.async {
                        self.remainingTimeString = "\(remainingMinutes):\(remainingSeconds)"
                        self.remainingTimeSeconds = remainingTime
                    }
                }
                timer?.resume()
                isTimerRunning = true
            }
        }
    //
    //    func remainingTime() -> (minutes: Int, seconds: Int) {
    //        let remainingSeconds = Int((1 - self.progressModel.progress) * self.progressModel.totalTime)
    //        let minutes = remainingSeconds / 60
    //        let seconds = remainingSeconds % 60
    //        return (minutes, seconds)
    //    }
    
    func stopTimer() {
          timer?.cancel()
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
    
    func changeCurrentProgress(value: String) {
        self.progressModel.totalTime = CGFloat(value.timeStringToSeconds())
    }
    
    func movingToBackground() {
        print("Moving to background!")
        timer?.cancel()
        backgroundDate = Date()
        backgroundProgress = progressModel.progress
    }
    
    @MainActor
    func movingToForeground() {
        print("Moving to foreground!")
        
        if let savedProgress = backgroundProgress {
            let deltaTime = Int(Date().timeIntervalSince(backgroundDate).rounded())
            let remainingTime = Int((1 - savedProgress) * progressModel.totalTime) - deltaTime
            
            if remainingTime > 0 {
                let updatedProgress = savedProgress + (CGFloat(deltaTime) / progressModel.totalTime)
                
                // Check if the updated progress exceeds 1
                if updatedProgress < 1 {
                  
                        self.progressModel.progress = updatedProgress
                        self.remainingTimeSeconds = remainingTime
                        self.startTimer()
               
                } else {
                    // If the progress exceeds 1, set it to 1 and stop the timer
                   
                        self.progressModel.progress = 1
                        self.remainingTimeSeconds = 0
                        self.stopTimer()
                    
                }
            }
            
            // Reset the saved progress and background date
            backgroundProgress = nil
        }
    }

}
