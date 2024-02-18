//
//  HomeView.swift
//  PomodoroApp
//
//  Created by Elif Bilge Parlak on 9.12.2023.
//

import SwiftUI
import SwiftData
import MCEmojiPicker

 struct HomeView: View {
    //MARK: - Variables
    @EnvironmentObject private var viewModel: HomeViewModel
    @State private var isAddTaskSheetOpen = false
    @State private var isAlreadyFocusing = false
    @State private var path = [TaskModel]()
    @State private var isPresented: Bool = false
    @State private var textFieldText: String = ""
    let userDefaultsManager = UserDefaultManager.shared
    @AppStorage(UserDefaultsKey.currentTimerState.value) var currentTimerState: String?
    
    //MARK: - Body
    @ViewBuilder
    var body: some View {
        NavigationStack(path: $path) {
            ZStack() {
                Color.bgColor
                ScrollView {
                    VStack {
                        headlineView()
                        HomeTextFieldView(
                            isAddTaskSheetOpen: $isAddTaskSheetOpen,
                            textFieldText: $textFieldText, isPresented: isPresented)
                        tasksView()
                        Spacer()
                    }
                }.padding(.vertical, 50)
            }.edgesIgnoringSafeArea(.all)
                .navigationDestination(for: TaskModel.self) { task in
                    PomodoroView(
                        progressViewModel: ProgressViewModel(
                            progress: ProgressModel(
                                progress: 0,
                                totalTime: CGFloat(task.duration.timeStringToSeconds()),
                                timerState: currentTimerState?.convertToTimerState() ?? TimerState.notStarted),
                            currentTask: task
                            ),
                        taskModel: task
                    )
                }
        }
    }
    
    @ViewBuilder
    private func headlineView() -> some View {
        HStack {
            VStack (alignment: .leading, spacing: -10) {
                Text("Hello Glen,").font(.custom(Constants.TextConstants.baloo2SemiBold, size: 28))
                Text("Be productive today!").font(.custom(Constants.TextConstants.baloo2Medium, size: 18))
                    .font(.system(size: 20))
                    .foregroundColor(.black.opacity(0.6))
                
            }.frame(width: UIScreen.screenWidth - 70, height: 60,alignment: .leading)
            Image(systemName: "text.alignright")
        }.padding()
    }

    
    private func formatHourAndMinute(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
    
    //MARK: - All Tasks View
    @ViewBuilder
    private func tasksView() -> some View {
        VStack {
            HomeAllTasksView()
            //completedTaskView(fakeList: fakeList)
        }
    }
    
    //MARK: - Old Tasks View
    private func oldTaskView(task: TaskModel) -> some View {
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
                            Text(task.emoji).font(.system(size: 26))
                        }
                    VStack(alignment: .leading) {
                        Text(task.name)
                            .font(.custom(Constants.TextConstants.baloo2Medium , size: 16))
                        Text("\(task.duration)")
                            .font(.custom(Constants.TextConstants.baloo2Medium, size: 16))
                            .foregroundStyle(.gray)
                    }
                    Spacer()
                    Circle().frame(width: 35, height: 35).padding().foregroundStyle(Color.redTintColor).overlay {
                        Image("trashIcon")
                    }
                }.frame(width: 350, alignment: .leading)
            }
    }
}
//MARK: - Preview
#Preview {
    HomeView()
}


