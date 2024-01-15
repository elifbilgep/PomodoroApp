//
//  TaskModel.swift
//  PomodoroApp
//
//  Created by Elif Bilge Parlak on 18.12.2023.
//

import Foundation
import SwiftData

@Model
class TaskModel: Hashable {
    var name: String
    var duration: Double
    var emoji: String
    var date: String
    var isCompleted: Bool
    var session: Int
    var activeSession: Int
    var breakDuration: Double
    var taskId: String

    init(name: String = "",
         duration: CGFloat = 100.0,
         emoji: String = "💻",
         date: String = "22.2023",
         isCompleted: Bool = false,
         session: Int = 1,
         activeSession: Int = 1,
         breakDuration: Double = 5.0,
         taskId: String = "") {
        self.name = name
        self.duration = duration
        self.emoji = emoji
        self.date = date
        self.isCompleted = isCompleted
        self.session = session
        self.activeSession = activeSession
        self.breakDuration = breakDuration
        self.taskId = UUID().uuidString
    }
}
