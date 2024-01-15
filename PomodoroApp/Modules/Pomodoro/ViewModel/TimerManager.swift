//
//  ProgressModel,.swift
//  PomodoroApp
//
//  Created by Elif Bilge Parlak on 23.12.2023.
//

import Foundation
import Combine

enum TimerState {
    case notStarted
    case focusing
    case pausing
}

enum TimingPlan: String {
    case short = "15:00"
    case medium = "30:00"
    case long = "45:00"
    
    var timeLength: Double {
        switch self {
        case .short:
            return 15
        case .medium:
            return 30
        case .long:
            return 45
        }
    }
}

class TimerManager: ObservableObject {
    
    @Published private(set) var timerState: TimerState = .notStarted
    @Published private(set) var timingPlan: TimingPlan = .short
    @Published private(set) var startTime: Date
    @Published private(set) var endTime: Date
    @Published private(set) var elapsed: Bool = false
    @Published private(set) var elapsedTime: Double = 0.0
    @Published private(set) var progress: Double = 0.0
    
    var focusingTime: Double 
    var pausingTime: Double
    private var cancellables: Set<AnyCancellable> = []
    
    init(focusingTime: Double, pausingTime: Double) {
        startTime = Date()
        endTime = Date()
        self.focusingTime = focusingTime * 60
        self.pausingTime = pausingTime * 60
        
        $timerState.sink { [weak self] timerState in
            guard let self = self else { return }
            if timerState == .focusing {
                self.startTime = Date()
                self.endTime = self.startTime.addingTimeInterval(self.focusingTime)
            } else if timerState == .pausing {
               // self.startTime = Date()
               // self.endTime = self.startTime.addingTimeInterval(self.pausingTime)
                
            }
        }
        .store(in: &cancellables)
    }
    
    // Switch from focus mode to pause and back
    func toggleTimerState() {
        timerState = timerState == .focusing ? .pausing: .focusing
        elapsedTime = 0.0
        progress = 0.0
    }
    
    // To get notified when the remaining timer is elapsed
    func track() {
        guard timerState != .notStarted else { return }
        
        if timerState == .focusing {
            if endTime >= Date() {
                print("Not elapsed")
                elapsed = false
            } else {
                print("Elapsed")
                elapsed = true
            }
            
            elapsedTime += 1
            print("Elapsed time: ", elapsedTime)
            
            // Progress calculation
            let totalTime = focusingTime
            progress = (elapsedTime / totalTime * 100).rounded() / 100
            print(progress)
        }
    }
    
    // Reset the state at non-started
    func reset() {
        timerState = .notStarted
        elapsedTime = 0.0
        progress = 0.0
        startTime = Date()
        endTime = Date()
    }
    
    func stop() {
        timerState = .pausing
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
    }

    // Change timing plan case
    func switchTiming() {
        if timingPlan == .short {
            timingPlan = .medium
        } else if timingPlan == .medium {
            timingPlan = .long
        } else if timingPlan == .long {
            timingPlan = .short
        }
        
        reset()
    }
}
