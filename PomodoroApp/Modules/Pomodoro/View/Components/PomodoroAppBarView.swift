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
    var userDefaults = UserDefaultManager.shared
    var homeViewModel: HomeViewModel
    
    var body: some View {
        HStack {
            Image(systemName: "chevron.backward").font(.system(size: 22))
                .onTapGesture {
                    if progressVM.currentTimerState == .notStarted {
                        presentationMode.wrappedValue.dismiss()
                    } else {
                        userDefaults.set(progressVM.progressModel.remainingTimeValue, for: .currentTimeValue)
                        userDefaults.set(taskModel.taskId, for: .currentTaskId)
                        userDefaults.set(progressVM.currentTimerState.rawValue, for: .currentTimerState)
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            Spacer()
            Text("Pomodoro Timer").font(.custom(Constants.TextConstants.baloo2Regular, size: 22)).foregroundStyle(.black.opacity(0.6))
            Spacer()
           
                Image(systemName: "trash.fill").onTapGesture {
                    homeViewModel.removeItem(task: taskModel)
                    presentationMode.wrappedValue.dismiss()
                }
            
            
        }.frame(width: UIScreen.screenWidth - 50, height: 50)
    }
}

#Preview {
    let fakeTaskModel = Constants.fakeTaskModel
    let fakeProgressModel = Constants.fakeProgressModel
    let progressVM = ProgressViewModel(progress: fakeProgressModel, currentTask: fakeTaskModel)
    return PomodoroAppBarView(progressVM: progressVM, taskModel: fakeTaskModel, homeViewModel: HomeViewModel())
}
