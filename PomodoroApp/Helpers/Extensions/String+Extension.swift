//
//  String+Extension.swift
//  PomodoroApp
//
//  Created by Elif Bilge Parlak on 2.01.2024.
//

import Foundation

extension String {
    func timeStringToSeconds() -> Int {
        let components = self.components(separatedBy: ":")

        guard components.count >= 2,
              let minutes = Int(components[0]),
              let seconds = Int(components[1]) else {
            return 0 // Return 0 if the conversion fails
        }

        return minutes * 60 + seconds
    }
}
