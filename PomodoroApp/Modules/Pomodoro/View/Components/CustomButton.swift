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
    @State var buttonType: ButtonType
    var onTap: (() -> Void)?

    enum ButtonType: String {
        case start = "Start"
        case giveaBreak = "Give a Break"
        case stop = "Stop"
        case giveUp = "Give Up"
        case returnToWork = "Return to Work"
    }

    var body: some View {
        RoundedRectangle(cornerRadius: 20)
            .foregroundStyle(color ?? .red.opacity(0.6))
            .overlay {
                Text(buttonType.rawValue)
            }.onTapGesture {
                onTap?()
            }
            .frame(width: 300,height: 60)
            .font(.custom(Constants.TextConstants.baloo2Medium, size: 18))
            .foregroundStyle(.white)
    }
}

#Preview {
    return CustomButton(buttonType: .returnToWork)
}

