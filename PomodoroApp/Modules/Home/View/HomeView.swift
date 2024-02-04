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
    @State private var viewModel: HomeViewModel
    @State private var isAddTaskSheetOpen = false
    @State private var isAlreadyFocusing = false
    @State var textFieldText: String = ""
    @State var path = [TaskModel]()
    @State var time: CGFloat = 1.0
    @State var isPresented: Bool = false
    @State var selectedEmoji: String = "😇"
    @State var selectedSession: Int = 1
    let sessions: [Int] = [1,2,3,4,5]
    @State private var selectedMinutes: Int = 15
    @State private var selectedBreakMin: Int = 10
    @AppStorage(UserDefaultsKey.currentTimerState.value) var currentTimerState: String?
    
    
    //MARK: - Init
    init(modelContext: ModelContext) {
        let viewModel = HomeViewModel(modelContext: modelContext)
        _viewModel = State(initialValue: viewModel)
        
    }
    
    //MARK: - Body
    @ViewBuilder
    var body: some View {
        NavigationStack(path: $path) {
            ZStack() {
                Color.bgColor
                ScrollView {
                    VStack {
                        headlineView()
                        addTaskView()
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
                                remainingTimeValue:  "",
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
    
    //MARK: - Add Task View
    @ViewBuilder
    private func addTaskView() -> some View {
        RoundedRectangle(cornerRadius: 20)
            .foregroundStyle(.white)
            .overlay {
                HStack() {
                    Text(textFieldText == "" ? "New task here..." : textFieldText)
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
                            .mask(Text((textFieldText == "" ? "New task here..." : textFieldText)).font(.custom(Constants.TextConstants.baloo2Medium, size: 18)))
                        )
                    Spacer()
                    Button(action: {
                        isAddTaskSheetOpen.toggle()
                    }, label: {
                        Text("+").font(.system(size: 24))
                            .foregroundStyle(Color.primaryColor)
                    })
                }.padding(.horizontal, 20)
            }.frame(width: 350, height: 60)
            .sheet(isPresented: $isAddTaskSheetOpen, content: sheetView)
    }
    //MARK: - SheetView
    @ViewBuilder
    private func sheetView() -> some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Add New Task")
                .font(.custom(Constants.TextConstants.baloo2Medium, size: 24))
            HStack {
                Button(selectedEmoji) {
                    isPresented.toggle()
                }.emojiPicker(
                    isPresented: $isPresented,
                    selectedEmoji: $selectedEmoji
                ).frame(width: 50, height: 50)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                
                TextField("New Task Name", text: $textFieldText)
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
                    name: textFieldText,
                    duration: CGFloat(selectedMinutes),
                    emoji: selectedEmoji,
                    date: Date.now.formatted(.dateTime),
                    isCompleted: false,
                    session: selectedSession,
                    breakDuration: String(selectedBreakMin)
                )
                
                viewModel.addTask(task: newTask)
                isAddTaskSheetOpen.toggle()
                textFieldText = ""
            }, label: {
                Text("Add Task").frame(width: 330,height: 30)
                
            })
            .tint(Color.primaryColor)
            .buttonStyle(.borderedProminent)
            
        }
        .frame(width: 350, height: 400, alignment: .top).presentationDetents([.height(500)])
        .font(.custom(Constants.TextConstants.baloo2Medium, size: 16))
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
            allTaskView()
            //completedTaskView(fakeList: fakeList)
        }
    }
    
    @ViewBuilder
    private func allTaskView() -> some View {
        VStack {
            Text("All Tasks")
                .font(.custom(Constants.TextConstants.baloo2SemiBold, size: 20))
                .foregroundColor(.black.opacity(0.6))
                .frame(width: 350, height: 20, alignment: .leading).padding()
            
            ForEach(viewModel.allTasks) { task in
                taskView(task: task)
            }
        }
    }
    
    
    //MARK: - Task View
    @ViewBuilder
    private func taskView(task: TaskModel) -> some View {
        HomeTaskView(task: task)
        
    }
    
    //MARK: - Completed Task View
    //    private func completedTaskView(fakeList: [(String, String, String)]) -> some View {
    //        return VStack {
    //            Text("Completed Tasks")
    //                .font(.custom(Constants.TextConstants.baloo2SemiBold, size: 20))
    //                .foregroundColor(.black.opacity(0.6))
    //                .frame(width: 350, height: 20, alignment: .leading).padding()
    //
    //            ForEach(fakeList, id: \.0) { item in
    //                oldTaskView(task: TaskModel(name: item.0, duration: item.2, emoji: "🐝", date: "22.12.2023", isCompleted: true)).padding(.vertical, 3)
    //            }
    //        }
    //
    //
    
    
    
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
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: TaskModel.self, configurations: config)
        let example = TaskModel()
        return HomeView(modelContext: container.mainContext)
            .modelContainer(container)
    } catch {
        fatalError("Failed to create a model container")
    }
    
}


