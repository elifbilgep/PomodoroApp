//
//  PomodoroView.swift
//  PomodoroApp
//
//  Created by Elif Bilge Parlak on 11.12.2023.
//

import SwiftUI

struct PomodoroView: View {
    //MARK: - Variables
    var progressViewModel: ProgressViewModel
    @Bindable var taskModel: TaskModel
    @AppStorage("currentTimeValue") var currentTimeValue: String?
    @AppStorage("currentTaskId") var currentaskId: String?
    @AppStorage("currentState") var currentTimerState: String?
    
    //MARK: - Initalize
    init(progressViewModel: ProgressViewModel, taskModel: TaskModel) {
        self.progressViewModel = progressViewModel
        self.taskModel = taskModel
        progressViewModel.fetchTimerState(currentState: currentTimerState)
    }
    
    //MARK: - Body
    @ViewBuilder
    var body: some View {
        ZStack {
            Color(Color.bgColor)
            VStack {
                appBarView()
                currentTaskView()
                pomodoroClockView().padding(.vertical, 50)
                stayFocusedView()
                buttonsView()
                Spacer()
            }.padding(.vertical, 70)
        }.navigationBarBackButtonHidden(true)
            .ignoresSafeArea()
    }
    
    //MARK: - App Bar
    @ViewBuilder
    private func appBarView() -> some View {
        PomodoroAppBarView(
            progressVM: progressViewModel, taskModel: taskModel)
    }
    
    //MARK: - Current Task View
    @ViewBuilder
    private func currentTaskView() -> some View {
        CurrentTaskView(taskModel: taskModel, timerState: progressViewModel.progressModel.timerState)
    }
    
    //MARK: - Pomodoro Clock View
    @ViewBuilder
    private func pomodoroClockView() -> some View {
        CircleProgressView(
            progressViewModel: progressViewModel,
            task: taskModel)
    }
    
    private func stayFocusedView() -> some View {
        Text("Stay focused for \((taskModel.duration).toInt())")
            .font(.custom(Constants.TextConstants.baloo2Medium, size: 16))
            .foregroundStyle(.gray.opacity(0.8))
    }
    
    // MARK: Buttons View
    @ViewBuilder
    private func buttonsView() -> some View {
            PomodoroButtonsView(progressViewModel: progressViewModel)
    }
}

#Preview {
    return  PomodoroView(
        progressViewModel: Constants.fakeProgressViewModel,
        taskModel: Constants.fakeTaskModel)
}

