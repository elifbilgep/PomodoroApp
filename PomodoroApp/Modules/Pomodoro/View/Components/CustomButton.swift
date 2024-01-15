//
//  CustomButton.swift
//  PomodoroApp
//
//  Created by Elif Bilge Parlak on 29.12.2023.
//

import SwiftUI

struct CustomButton: View {
    var title: String
    var gradient: LinearGradient?
    var color: Color?
    @State var viewModel: ProgressViewModel
    @State var buttonType: ButtonType

    enum ButtonType: String {
        case giveaBreak = "Give a Break"
        case giveUp = "Give Up"
        case returnToWork = "Return to Work"
    }

    var body: some View {
        RoundedRectangle(cornerRadius: 20)
            .foregroundStyle(color ?? .red.opacity(0.6))
            .overlay {
                Text(buttonType.rawValue)
            }.onTapGesture {
                viewModel.pauseOrResumeTimer()
                if buttonType == .returnToWork {
                    buttonType = .giveaBreak
                } else {
                    buttonType = .returnToWork
                }
            }
            .frame(width: 300,height: 60)
            .font(.custom(Constants.TextConstants.baloo2Medium, size: 18))
            .foregroundStyle(.white)
    }
}

#Preview {
    let progressVM = ProgressViewModel(progress: ProgressModel(progress: 1, circleProgress: 1, totalTime: 1))
    return CustomButton(title: "", viewModel: progressVM, buttonType: .returnToWork)
}

