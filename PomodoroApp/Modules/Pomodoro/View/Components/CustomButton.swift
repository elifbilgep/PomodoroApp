//
//  CustomButton.swift
//  PomodoroApp
//
//  Created by Elif Bilge Parlak on 29.12.2023.
//

import SwiftUI

struct CustomButton: View {
    var gradient: LinearGradient?
    var color: Color?
    @Binding var timerState: TimerState?
    var title: String?
    var onTap: (() -> Void)?
    

    var body: some View {
        RoundedRectangle(cornerRadius: 20)
            .foregroundStyle(color ?? .red.opacity(0.6))
            .overlay {
                Text(title ?? buttonTitle())
            }.onTapGesture {
                onTap?()
            }
            .frame(width: 300,height: 60)
            .font(.custom(Constants.TextConstants.baloo2Medium, size: 18))
            .foregroundStyle(.white)
    }
    
    func buttonTitle() -> String {
        switch timerState {
        case .notStarted:
            return "Start to work"
        case .focusing:
           return "Pause"
        case .pause:
            return "Resume"
        case .none:
            return ""
        }
    }
    
}


