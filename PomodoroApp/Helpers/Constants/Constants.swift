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
}


func ??<T>(lhs: Binding<Optional<T>>, rhs: T) -> Binding<T> {
    Binding(
        get: { lhs.wrappedValue ?? rhs },
        set: { lhs.wrappedValue = $0 }
    )
}
