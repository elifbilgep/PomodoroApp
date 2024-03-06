//
//  TaskStatusView.swift
//  PomodoroApp
//
//  Created by Elif Parlak on 4.02.2024.
//

import SwiftUI

struct TaskStatusView: View {
    let imageName: String
    let color: Color
    
    var body: some View {
        VStack {
            Circle()
                .frame(width: 35, height: 35)
                .padding()
                .foregroundStyle(color)
                .overlay {
                    Image(imageName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 20, height: 20)
                }
                .frame(height: 20)
        }
    }
}

#Preview {
    TaskStatusView(imageName: "noEnterIcon", color: .red.opacity(0.5))
}
