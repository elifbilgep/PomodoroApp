//
//  PomodoroView.swift
//  PomodoroApp
//
//  Created by Elif Bilge Parlak on 11.12.2023.
//

import SwiftUI
import Combine

struct PomodoroView: View {
    //MARK: - Variables
    @ObservedObject var timerManager: TimerManager
    @Bindable var taskModel: TaskModel
    
    @Environment(\.presentationMode) var presentationMode
    @AppStorage("currentTimeValue") var currentTimeValue: String?
    @AppStorage("currentTaskId") var currentTaskId: String?
    @Environment(\.scenePhase) var phase
    
    let timerObject = Timer
        .publish(every: 1, on: .main, in: .common)
        .autoconnect()
    var cancellable: AnyCancellable?
    
    //MARK: - Initalize
    init(taskModel: TaskModel) {
        self.taskModel = taskModel
        self.timerManager = TimerManager(
            focusingTime: taskModel.duration,
            pausingTime: taskModel.breakDuration)
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
                completeTheTask()
                if timerManager.timerState == .notStarted {
                    CustomButton(
                        color: Color.primaryColor,
                        buttonType: .start) {
                            timerManager.toggleTimerState()
                        }
                } else if timerManager.timerState == .focusing {
                    CustomButton(
                        color: Color.primaryColor,
                        buttonType: .stop) {
                          print("stop")
                            timerManager.stop()
                         
                        }
                } else if timerManager.timerState == .pausing {
                    CustomButton(
                        color: Color.primaryColor,
                        buttonType: .start) {
                            timerManager.toggleTimerState()
                        }
                }
                
                CustomButton(buttonType: .giveUp)
                Spacer()
            }.padding(.vertical, 70)
        }.navigationBarBackButtonHidden(true)
            .ignoresSafeArea()
            .onChange(of: phase) { oldPhase, newPhase in
                switch newPhase {
                case .active:
                    print("Active State")
                case .inactive:
                    AppStateManager.shared.isActiveState = false
                case .background:
                    print("Inactive State")
                @unknown default:
                    print("Unknown state")
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
                    //                    UserDefaults.standard.set(progressViewModel.remainingTimeString, forKey: "currentTimeValue")
                    //                    UserDefaults.standard.set(taskModel.taskId, forKey: "currentTaskId")
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
                            Text(taskModel.emoji)
                                .font(.system(size: 26))
                        }
                    VStack(alignment: .leading) {
                        Text(taskModel.name)
                            .font(.custom(  Constants.TextConstants.baloo2Medium , size: 16))
                            .lineLimit(1)
                            .truncationMode(.tail)
                        Text("\((taskModel.duration)) Minutes")
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
                    .trim(from: 0.0, to: CGFloat(min(timerManager.progress, 1.0)))
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
                    if timerManager.timerState == .notStarted {
                        Text("00:00")
                            .font(.custom(
                                Constants.TextConstants.baloo2Medium, size: 52)).fontWeight(.bold)
                    }
                    else {
                        Text(timerManager.endTime, style: .timer)
                            .font(.custom(
                                Constants.TextConstants.baloo2Medium, size: 52))
                            .fontWeight(.bold)
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
                        x: 125 * cos(2 * .pi * Double(timerManager.progress)),
                        y: 125 * sin(2 * .pi * Double(timerManager.progress ))
                    )
                    .rotationEffect(Angle(degrees: -90))
                
            }.frame(width: 250, height: 250)
                .padding()
                .onReceive(timerObject) { _ in
                    timerManager.track()
                }
        }
    }
    
    private func completeTheTask() -> some View {
        Button("Complete it early") {
            timerManager.toggleTimerState()
        }
    }
}


#Preview {
    return  PomodoroView(taskModel: TaskModel(name: "Work hard",duration: 15.0))
}

