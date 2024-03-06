//
//  PomodoroView.swift
//  PomodoroApp
//
//  Created by Elif Bilge Parlak on 11.12.2023.
//

import SwiftUI

struct PomodoroView: View {
    //MARK: - Variables
    let progressViewModel: ProgressViewModel
    let taskModel: TaskModel
    let userDefaultsManager = UserDefaultManager.shared
    let homeViewModel: HomeViewModel
    
    //MARK: - Initalize
    init(progressViewModel: ProgressViewModel,
         taskModel: TaskModel,
         homeViewModel: HomeViewModel) {
        self.progressViewModel = progressViewModel
        self.taskModel = taskModel
        self.homeViewModel = homeViewModel
    }
    
    //MARK: - Body
    @ViewBuilder
    var body: some View {
        ZStack {
            Color(Color.bgColor)
            VStack {
                PomodoroAppBarView(
                    progressVM: progressViewModel,
                    taskModel: taskModel,
                    homeViewModel: homeViewModel)
                CurrentTaskView(
                    taskModel: taskModel,
                    timerState: progressViewModel.currentTimerState)
                CircleProgressView(
                    progressViewModel: progressViewModel,
                    task: taskModel)
                stayFocusedView()
                PomodoroButtonsView(
                    progressViewModel: progressViewModel)
                Spacer()
            }.padding(.vertical, 70)
        }.navigationBarBackButtonHidden(true)
            .ignoresSafeArea()
    }
    
    private func stayFocusedView() -> some View {
        Text("Stay focused for \((taskModel.duration).toInt())")
            .font(.custom(Constants.TextConstants.baloo2Medium, size: 16))
            .foregroundStyle(.gray.opacity(0.8))
    }
}

#Preview {
    return  PomodoroView(
        progressViewModel: Constants.fakeProgressViewModel,
        taskModel: Constants.fakeTaskModel,
        homeViewModel: HomeViewModel())
}

