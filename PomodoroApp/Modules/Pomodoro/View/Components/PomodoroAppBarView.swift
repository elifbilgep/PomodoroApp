//
//  CustomAppBarView.swift
//  PomodoroApp
//
//  Created by Elif Parlak on 28.01.2024.
//

import SwiftUI

struct PomodoroAppBarView: View {
    @Environment(\.presentationMode) var presentationMode
    var progressVM: ProgressViewModel
    var taskModel: TaskModel

    var body: some View {
        HStack {
            Image(systemName: "chevron.backward").font(.system(size: 22))
                .onTapGesture {
                    presentationMode.wrappedValue.dismiss()
                    UserDefaults.standard.set(
                        progressVM.progressModel.remainingTimeValue,
                        forKey: "currentTimeValue")
                    UserDefaults.standard.set(
                        taskModel.taskId,
                        forKey: "currentTaskId")
                    UserDefaults.standard.set(
                        progressVM.progressModel.timerState.rawValue,
                        forKey: "currentState")
                }
            Spacer()
            Text("Pomodoro Timer").font(.custom(Constants.TextConstants.baloo2Regular, size: 22)).foregroundStyle(.black.opacity(0.6))
            Spacer()
            Image(systemName: "chevron.backward").opacity(0)
        }.frame(width: UIScreen.screenWidth - 50, height: 50)
    }
}

#Preview {
    let fakeTaskModel = Constants.fakeTaskModel
    let fakeProgressModel = Constants.fakeProgressModel
    let progressVM = ProgressViewModel(progress: fakeProgressModel, currentTask: fakeTaskModel)
    return PomodoroAppBarView(progressVM: progressVM, taskModel: fakeTaskModel)
}
