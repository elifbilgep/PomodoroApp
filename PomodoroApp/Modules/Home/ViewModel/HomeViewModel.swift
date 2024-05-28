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
    var isAddTaskSheetOpen = false
    var isAlreadyFocusing = false
    var path = [TaskModel]()
    var isPresented: Bool = false
    var textFieldText: String = ""
    
    init() {
        self.dataSource = TaskDataSource.shared
        allTasks = dataSource.fetchItems()
    }
    
    func appendTask(newTask: TaskModel) {
        dataSource.appendTask(newTask: newTask)
        allTasks = dataSource.fetchItems()
    }
    
    func removeItem(task: TaskModel) {
        dataSource.removeItem(task)
        allTasks = dataSource.fetchItems()
    }
}
