//
//  CircleProgressView.swift
//  PomodoroApp
//
//  Created by Elif Parlak on 28.01.2024.
//

import SwiftUI

struct CircleProgressView: View {
    var progressViewModel: ProgressViewModel
    var task: TaskModel
    @AppStorage("currentTimeValue") var currentTimeValue: String?
    @AppStorage("currentTaskId") var currentaskId: String?
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 20.0)
                .foregroundColor(Color.clockBgColor)
            
            Circle()
                .trim(from: 0.0, to: progressViewModel.progressModel.progress)
                .stroke(style: StrokeStyle(lineWidth: 20.0, lineCap: .round, lineJoin: .round))
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.primaryColor, Color.primaryColor200]),
                        startPoint: .topTrailing,
                        endPoint: .topLeading
                    )
                )
                .rotationEffect(Angle(degrees: -90))
            
            VStack {
                Text(progressViewModel.progressModel.remainingTimeValue)
                    .font(.custom(Constants.TextConstants.baloo2Bold, size: 52))
                    .foregroundColor(Color.clockTextColor)
                    .frame(height: 30)
                Text("\(task.activeSession) of \(task.session) session")
                    .font(.custom(Constants.TextConstants.baloo2Medium, size: 15))
                    .foregroundStyle(.gray.opacity(0.8))
                
            }
            Circle()
                .frame(width: 30, height: 30)
                .foregroundColor(.white)
                .shadow(color: .gray.opacity(0.3) ,radius: 10)
                .overlay(content: {
                    Circle().frame(width: 15, height: 15, alignment: .center).foregroundStyle(Color.primaryColor)
                })
                .offset(
                    x: 125 * cos(2 * .pi * Double(progressViewModel.progressModel.progress)),
                    y: 125 * sin(2 * .pi * Double(progressViewModel.progressModel.progress))
                )
                .rotationEffect(Angle(degrees: -90))
        }.frame(width: 250, height: 250)
            .onAppear {
                if let currentTimeValue {
                    progressViewModel.changeTimerRemaining(with: currentTimeValue)
                }
            }
    }
}

#Preview {
    @State var progress = Constants.fakeProgressModel
    var progressViewModel = ProgressViewModel(progress: progress)
    let task = TaskModel()
    return CircleProgressView(progressViewModel: progressViewModel, task: task)
}
