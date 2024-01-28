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
            .onAppear {
                progressViewModel.fetchTimerState(
                    currentState: currentTimerState)
            }
        
    }
    
    //MARK: - App Bar
    @ViewBuilder
    private func appBarView() -> some View {
        PomodoroAppBarView(
            progressModel: progressViewModel.progressModel,
            taskModel: taskModel)
    }
    
    //MARK: - Current Task View
    @ViewBuilder
    private func currentTaskView() -> some View {
        CurrentTaskView(taskModel: taskModel)
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
        CustomButton(
            color: Color.primaryColor,
            timerState: progressViewModel.timerState) {
            progressViewModel.togglePauseandResume()
        }
        CustomButton(timerState: progressViewModel.timerState, title: "Give Up") {
            progressViewModel.resetTimer()
        }
    }
}

#Preview {
    let progressModel = ProgressModel(progress: 0, totalTime: 900, remainingTimeValue: "14:50")
    let progressVM = ProgressViewModel(progress: progressModel)
    return  PomodoroView(progressViewModel: progressVM, taskModel: TaskModel(name: "Work hard",duration: 15.0))
}

