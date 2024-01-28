//
//  Constants.swift
//  PomodoroApp
//
//  Created by Elif Bilge Parlak on 9.12.2023.
//

import SwiftUI
struct Constants {

    enum TextConstants {
        static let baloo2Regular = "Baloo2-Regular"
        static let baloo2Medium = "Baloo2-Medium"
        static let baloo2SemiBold = "Baloo2-SemiBold"
        static let baloo2Bold = "Baloo2-Bold"
    }
    
    static let fakeTaskModel = TaskModel(
        name: "Complete Assignment",
        duration: 2.5,
        emoji: "📚",
        date: "01.2024",
        isCompleted: false,
        session: 2,
        activeSession: 1,
        breakDuration: "00:05"
    )
    
    static let fakeProgressModel = ProgressModel(progress: 1.0, totalTime: 1.0, remainingTimeValue: "15:00")
}


func ??<T>(lhs: Binding<Optional<T>>, rhs: T) -> Binding<T> {
    Binding(
        get: { lhs.wrappedValue ?? rhs },
        set: { lhs.wrappedValue = $0 }
    )
}
