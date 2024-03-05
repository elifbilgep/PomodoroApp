//
//  TaskModelDataSource.swift
//  PomodoroApp
//
//  Created by Elif Parlak on 29.02.2024.
//

import Foundation
import SwiftData

final class TaskDataSource {
    let modelContainer: ModelContainer
    let modelContext: ModelContext
    
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
        do {
            return  try modelContext.fetch(FetchDescriptor<TaskModel>())
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    func removeItem(_ task: TaskModel) {
        modelContext.delete(task)
    }
    
    
    func removeAllTask() {
      
         modelContext.container.deleteAllData()
 
      
        
    }
}
