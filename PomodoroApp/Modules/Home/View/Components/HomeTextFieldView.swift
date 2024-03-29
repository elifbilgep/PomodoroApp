//
//  HomeTextField.swift
//  PomodoroApp
//
//  Created by Elif Parlak on 4.02.2024.
//

import SwiftUI

struct HomeTextFieldView: View {
    @State private var selectedEmoji: String = "😇"
    @State private var selectedMinutes: Int = 15
    @State private var selectedBreakMin: Int = 10
    @State private var selectedSession: Int = 1
    private let sessions: [Int] = [1,2,3,4,5]
    @State var homeViewModel: HomeViewModel
    let userDefaults = UserDefaultManager.shared
    
    var body: some View {
        RoundedRectangle(cornerRadius: 20)
            .foregroundStyle(.white)
            .overlay {
                HStack() {
                    Text(homeViewModel.textFieldText == "" ? "New task here..." : homeViewModel.textFieldText)
                        .font(.custom(Constants.TextConstants.baloo2Medium, size: 18))
                        .overlay(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color.secondaryColor,
                                    Color.primaryColor,
                                ]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                            .mask(Text((homeViewModel.textFieldText == "" ? "New task here..." : homeViewModel.textFieldText)).font(.custom(Constants.TextConstants.baloo2Medium, size: 18)))
                        )
                    Spacer()
                    Button(action: {
                        homeViewModel.isAddTaskSheetOpen.toggle()
                    }, label: {
                        Text("+").font(.system(size: 24))
                            .foregroundStyle(Color.primaryColor)
                    })
                }.padding(.horizontal, 20)
            }.frame(width: 350, height: 60)
            .sheet(isPresented: $homeViewModel.isAddTaskSheetOpen) {
                VStack(alignment: .leading, spacing: 20) {
                    Spacer()
                    Text("Add New Task")
                        .font(.custom(Constants.TextConstants.baloo2Medium, size: 24))
                    HStack {
                        Button(selectedEmoji) {
                            homeViewModel.isPresented.toggle()
                        }.emojiPicker(
                            isPresented: $homeViewModel.isPresented,
                            selectedEmoji: $selectedEmoji
                        ).frame(width: 50, height: 50)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(10)
                        
                        TextField("New Task Name", text: $homeViewModel.textFieldText)
                            .font(.custom(Constants.TextConstants.baloo2Medium, size: 18))
                            .padding(10)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(10)
                            .tint(Color.primaryColor)
                    }
                    HStack {
                        Text("Minutes per work:")
                        Spacer()
                        HStack {
                            Text("\(selectedMinutes)")
                            Stepper("", value: $selectedMinutes, in: 0...60, step: 5)
                        }
                    }
                    HStack {
                        Text("Minutes per break:")
                        Spacer()
                        HStack {
                            Text("\(selectedBreakMin)")
                            Stepper("", value: $selectedBreakMin, in: 10...30, step: 5)
                        }
                    }
                    HStack {
                        Text("Sessions: ")
                        Picker("Sessions", selection: $selectedSession) {
                            ForEach(sessions, id: \.self) { session in
                                Text("\(session)")
                            }
                        }.pickerStyle(.segmented)
                    }
                    Button(action: {
                        let newTask = TaskModel(
                            name: homeViewModel.textFieldText,
                            duration: CGFloat(selectedMinutes),
                            emoji: selectedEmoji,
                            date: Date.now.formatted(.dateTime),
                            isCompleted: false,
                            session: selectedSession,
                            breakDuration: String(selectedBreakMin),
                            isEnter: userDefaults.get(for: .currentTimerState) == TimerState.focusing.rawValue ? false : true
                        )
                        homeViewModel.appendTask(newTask: newTask)
                        homeViewModel.isAddTaskSheetOpen.toggle()
                        homeViewModel.textFieldText = ""
                    }, label: {
                        Text("Add Task").frame(width: 330,height: 30)
                    })
                    .tint(Color.primaryColor)
                    .buttonStyle(.borderedProminent)
                    Spacer()
                    
                }
                .frame(width: 350, height: 400, alignment: .top)
                .presentationDetents([.height(400)])
                .font(.custom(Constants.TextConstants.baloo2Medium, size: 16))
            }
    }
}


#Preview {
    return HomeTextFieldView(homeViewModel: HomeViewModel())
}
