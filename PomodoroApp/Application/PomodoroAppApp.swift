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
    let homeViewModel : HomeViewModel
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(homeViewModel)
        }
    }

    init() {
        do {
            container = try ModelContainer(for: TaskModel.self)
            self.homeViewModel = HomeViewModel(modelContext: container.mainContext)
        } catch {
            fatalError("Failed to create ModelContainer for Destiantion")
        }
    }
}
