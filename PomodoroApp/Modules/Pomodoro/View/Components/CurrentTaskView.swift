//
//  CurrentTaskView.swift
//  PomodoroApp
//
//  Created by Elif Parlak on 28.01.2024.
//

import SwiftUI

struct CurrentTaskView: View {
    var taskModel: TaskModel
    @State private var rotationAngle: Double = 0
    
    var timerState: TimerState
    
    var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .frame(width: 350, height: 80)
            .foregroundStyle(.white)
            .overlay {
                HStack() {
                    RoundedRectangle(cornerRadius: 8)
                        .foregroundStyle(.gray.opacity(0.1))
                        .frame(width: 50, height: 50, alignment: .leading)
                        .padding(.horizontal, 8)
                        .overlay {
                            Text(taskModel.emoji)
                                .font(.system(size: 26))
                        }
                    VStack(alignment: .leading) {
                        Text(taskModel.name )
                            .font(.custom(  Constants.TextConstants.baloo2Medium , size: 16))
                            .lineLimit(1)
                            .truncationMode(.tail)
                        Text("\((taskModel.duration).toInt()) Minutes")
                            .font(.custom(  Constants.TextConstants.baloo2Medium, size: 16))
                            .foregroundStyle(.gray)
                        
                    }
                    Spacer()
                    buildTimerStateView()
                }.frame(width: 350, alignment: .leading)
            }
    }
    
    @ViewBuilder
    func buildTimerStateView() -> some View {
        if timerState == .focusing {
            ZStack {
                Circle()
                    .foregroundStyle(.gray.opacity(0.1))
                    .frame(width: 50, height: 50, alignment: .leading)
                Text("⏳")
                    .rotationEffect(Angle(degrees: rotationAngle))
                    .padding(.horizontal, 10)
                    .onAppear() {
                        withAnimation(Animation.linear(duration: 5.0).repeatForever(autoreverses: false)) {
                            rotationAngle = 360
                        }
                    }
                                
            }.padding(.horizontal, 10)
        } else if timerState == .notStarted {
            ZStack {
                Circle()
                    .foregroundStyle(.gray.opacity(0.1))
                    .frame(width: 50, height: 50, alignment: .leading)
                Text("✋")
                    .padding(.horizontal, 10)
            }.padding(.horizontal, 10)
        } else {
            ZStack {
                Circle()
                    .foregroundStyle(.gray.opacity(0.1))
                    .frame(width: 50, height: 50, alignment: .leading)
                Text("⏸️")
                    .padding(.horizontal, 10)
            }.padding(.horizontal, 10)
        }
        
    }
}

#Preview {
    let fakeTaskModel = Constants.fakeTaskModel
    return CurrentTaskView(taskModel: fakeTaskModel, timerState: .focusing)
}
