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
    var body: some Scene {
        WindowGroup {
            HomeView().preferredColorScheme(ColorScheme.light)
        }.modelContainer(TaskDataSource.shared.modelContainer)
    }
}
