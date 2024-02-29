//
//  HomeViewModel.swift
//  PomodoroApp
//
//  Created by Elif Bilge Parlak on 18.12.2023.
//

import Foundation
import SwiftData
import Observation

@Observable
class HomeViewModel {
    var allTasks: [TaskModel] = []
    var completedTasks: [TaskModel] = []
    private let dataSource: TaskDataSource
    
    init() {
        self.dataSource = TaskDataSource.shared
        allTasks = dataSource.fetchItems()
    }
    
    func appendTask(newTask: TaskModel) {
        dataSource.appendTask(newTask: newTask)
        allTasks = dataSource.fetchItems()
    }
    
    func removeItem(_ index: Int) {
        dataSource.removeItem(allTasks[index])
    }
    
}
