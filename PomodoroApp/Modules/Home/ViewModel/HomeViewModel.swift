//
//  HomeViewModel.swift
//  PomodoroApp
//
//  Created by Elif Bilge Parlak on 18.12.2023.
//

import Foundation
import SwiftData

@Observable
class HomeViewModel: ObservableObject {
     var allTasks: [TaskModel] = []
     var completedTasks: [TaskModel] = []

    var modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        fetchData()
    }

    func fetchData() {
        do {
            let descriptor = FetchDescriptor<TaskModel>()
            self.allTasks = try self.modelContext.fetch(descriptor)
        } catch {
            print("Fetching data failed")
        }
    }

    func addTask(task: TaskModel) {
        modelContext.insert(task)
        fetchData()
    }
    
    func convertToTimerState(timerString: String) -> TimerState{
        switch timerString {
        case TimerState.focusing.rawValue:
            return .focusing
        case TimerState.pause.rawValue:
            return .pause
        case TimerState.notStarted.rawValue:
            return .notStarted
        default:
            return .pause
        }
    }

}


