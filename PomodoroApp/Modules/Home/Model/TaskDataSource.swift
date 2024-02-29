//
//  TaskModelDataSource.swift
//  PomodoroApp
//
//  Created by Elif Parlak on 29.02.2024.
//

import Foundation
import SwiftData

final class TaskDataSource {
    private let modelContainer: ModelContainer
    private let modelContext: ModelContext
    
    @MainActor
    static let shared = TaskDataSource()
    
    @MainActor
    private init() {
        self.modelContainer = try! ModelContainer(for: TaskModel.self)
        self.modelContext = modelContainer.mainContext
    }
    
    func appendTask(newTask: TaskModel) {
        modelContext.insert(newTask)
        do {
            try modelContext.save()
            
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    func fetchItems() -> [TaskModel] {
        var list: [TaskModel] = []
        do {
            list = try modelContext.fetch(FetchDescriptor<TaskModel>())
            print(list.last?.name)
            return list
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    func removeItem(_ task: TaskModel) {
        modelContext.delete(task)
    }
}
