//
//  PomodoroAppApp.swift
//  PomodoroApp
//
//  Created by Elif Bilge Parlak on 9.12.2023.
//

import SwiftUI
import SwiftData


@main
struct PomodoroAppApp: App {
    let container: ModelContainer
    @AppStorage("currentTimeValue") var currentTimeValue: String = "0"

    var body: some Scene {
        WindowGroup {
            HomeView(modelContext: container.mainContext)
        }
    }

    init() {
        do {
            container = try ModelContainer(for: TaskModel.self)
        } catch {
            fatalError("Failed to create ModelContainer for Destiantion")
        }
    }
}
