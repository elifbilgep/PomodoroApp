//
//  String+Extension.swift
//  PomodoroApp
//
//  Created by Elif Bilge Parlak on 23.12.2023.
//

import Foundation

extension CGFloat {
    func timeStringToSeconds() -> CGFloat {
        return (self) * 60
    }

    func toInt() -> Int {
        return Int(self)
    }
}

