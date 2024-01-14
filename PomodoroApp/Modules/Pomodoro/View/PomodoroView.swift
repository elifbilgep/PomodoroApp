//
//  PomodoroView.swift
//  PomodoroApp
//
//  Created by Elif Bilge Parlak on 11.12.2023.
//

import SwiftUI

struct PomodoroView: View {
    //MARK: - Variables
    @ObservedObject var progressViewModel: ProgressViewModel
    @Bindable var taskModel: TaskModel
    @Environment(\.presentationMode) var presentationMode
    @AppStorage("currentTimeValue") var currentTimeValue: String?
    @AppStorage("currentTaskId") var currentTaskId: String?
    @Environment(\.scenePhase) var phase

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
                CustomButton(title: "Take a Break",color: Color.primaryColor, viewModel: progressViewModel, buttonType: .giveaBreak)
                CustomButton(title: "Give Up",viewModel: progressViewModel, buttonType: .giveUp)
                Spacer()
            }.padding(.vertical, 70)
        }.navigationBarBackButtonHidden(true)
            .ignoresSafeArea()
            .onChange(of: phase) { oldPhase, newPhase in
                switch newPhase {
                case .active:
                    DispatchQueue.main.async {
                        progressViewModel.movingToForeground()
                    }
                case .inactive:
                    AppStateManager.shared.isActiveState = false
                case .background:
                    progressViewModel.movingToBackground()
                @unknown default:
                    print("unknown state")
                }
            }
    }

    //MARK: - App Bar
    @ViewBuilder
    private func appBarView() -> some View {
        HStack {
            Image(systemName: "chevron.backward").font(.system(size: 22))
                .onTapGesture {
                    presentationMode.wrappedValue.dismiss()
                    UserDefaults.standard.set(progressViewModel.remainingTimeString, forKey: "currentTimeValue")
                    UserDefaults.standard.set(taskModel.taskId, forKey: "currentTaskId")
                }
            Spacer()
            Text("Pomodoro Timer").font(.custom(Constants.TextConstants.baloo2Regular, size: 22)).foregroundStyle(.black.opacity(0.6))
            Spacer()
            Image(systemName: "chevron.backward").opacity(0)
        }.frame(width: UIScreen.screenWidth - 50, height: 50)
    }

    //MARK: - Current Task View
   @ViewBuilder 
    private func currentTaskView() -> some View {
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
                            Text(taskModel.emoji ?? "")
                                .font(.system(size: 26))
                        }
                    VStack(alignment: .leading) {
                        Text(taskModel.name ??  "Task name" )
                            .font(.custom(  Constants.TextConstants.baloo2Medium , size: 16))
                            .lineLimit(1)
                            .truncationMode(.tail)
                        Text("\((taskModel.duration ?? 1.0).toInt()) Minutes")
                            .font(.custom(  Constants.TextConstants.baloo2Medium, size: 16))
                            .foregroundStyle(.gray)
                    }
                    Spacer()
                }.frame(width: 350, alignment: .leading)
            }
    }
    
    //MARK: - Pomodoro Clock
    @ViewBuilder
    private func pomodoroClockView() -> some View {
        VStack {
            ZStack {
                Circle()
                    .stroke(lineWidth: 20.0)
                    .foregroundColor(Color.clockBgColor)

                Circle()
                    .trim(from: 0.0, to: CGFloat(min(progressViewModel.progressModel.progress, 1.0)))
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
                    if currentTimeValue != nil {
                        Text((progressViewModel.remainingTimeString ?? currentTimeValue)!)
                            .font(.custom(Constants.TextConstants.baloo2Bold, size: 52))
                            .foregroundColor(Color.clockTextColor)
                            .frame(height: 30)
                    } else {
                        Text("\(progressViewModel.remainingTimeString ?? "\(Int(taskModel.duration!)):00")")
                        .font(.custom(Constants.TextConstants.baloo2Bold, size: 52))
                        .foregroundColor(Color.clockTextColor)
                        .frame(height: 30)
                        Text("\(taskModel.activeSession ?? 1) of \(taskModel.session ?? 1) session")
                            .font(.custom(Constants.TextConstants.baloo2Medium, size: 15))
                            .foregroundStyle(.gray.opacity(0.8))
                    }
                }.onAppear {
                    if currentTimeValue != nil && currentTaskId == taskModel.taskId {
                        progressViewModel.changeCurrentProgress(value: currentTimeValue!)
                    }
                }
                Circle()
                    .frame(width: 30, height: 30)
                    .foregroundColor(.white)
                    .shadow(color: .gray.opacity(0.3) ,radius: 10)
                    .overlay(content: {
                        Circle().frame(width: 15, height: 15, alignment: .center).foregroundStyle(Color.primaryColor)
                    })
                    .offset(
                        x: 125 * cos(2 * .pi * Double(progressViewModel.progressModel.progress )),
                        y: 125 * sin(2 * .pi * Double(progressViewModel.progressModel.progress ))
                    )
                    .rotationEffect(Angle(degrees: -90))

            }.frame(width: 250, height: 250)
                .padding()
                .onAppear() {
                    progressViewModel.startTimer()
                }
        }
    }

    private func stayFocusedView() -> some View {
        Text("Stay focused for \((taskModel.duration ?? 1.0).toInt())").font(.custom(Constants.TextConstants.baloo2Medium, size: 16)).foregroundStyle(.gray.opacity(0.8))
    }
}


#Preview {
    let progressModel = ProgressModel(progress: 0, circleProgress: 0, totalTime: 900)
    let progressVM = ProgressViewModel(progress: progressModel)
    return  PomodoroView(progressViewModel: progressVM, taskModel: TaskModel(name: "Work hard",duration: 15.0))
}

