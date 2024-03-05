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
    @AppStorage(UserDefaultsKey.currentTimerState.value) var currentTimerState: String?
    @State var homeViewModel = HomeViewModel()
    
    //MARK: - Body
    @ViewBuilder
    var body: some View {
        NavigationStack(path: $homeViewModel.path) {
            ZStack() {
                Color.bgColor
                ScrollView {
                    VStack {
                        headlineView()
                        HomeTextFieldView(
                            isAddTaskSheetOpen: $homeViewModel.isAddTaskSheetOpen,
                            textFieldText: $homeViewModel.textFieldText,
                            isPresented: homeViewModel.isPresented,
                            homeViewModel: homeViewModel)
                        musicView()
                        tasksView()
                        Spacer()
                    }
                }
                .padding(.vertical, 50)
            }.ignoresSafeArea()
                .navigationDestination(for: TaskModel.self) { task in
                    
                    PomodoroView(
                        progressViewModel: ProgressViewModel(
                            progress: ProgressModel(
                                progress: 0,
                                totalTime: CGFloat(task.duration.timeStringToSeconds()),
                                timerState: currentTimerState?.convertToTimerState() ?? TimerState.notStarted),
                            currentTask: task
                        ),
                        taskModel: task,
                        homeViewModel: homeViewModel
                    )
                }
        }
    }
    
    func setProgressVM() {
        
    }
    
    @ViewBuilder
    private func headlineView() -> some View {
        HStack {
            VStack (alignment: .leading, spacing: -10) {
                Text("Welcome").font(.custom(Constants.TextConstants.baloo2SemiBold, size: 28))
                Text("Be productive today!").font(.custom(Constants.TextConstants.baloo2Medium, size: 20))
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
            HomeAllTasksView(homeViewModel: homeViewModel)
            //completedTaskView(fakeList: fakeList)
        }
    }
    
     // MARK: Music View
    @ViewBuilder
    private func musicView() -> some View {
        let musicList = ["ocean", "forest", "night", "rain", "thunderstorm"]
        VStack(alignment: .leading) {
            Text("Calm Sounds").font(.custom(Constants.TextConstants.baloo2Medium, size: 20))
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(musicList, id: \.self ) { music in
                        Image(music)
                            .resizable()
                            .scaledToFit()
                            .cornerRadius(10)
                            .frame(width: 150, height: 200)
                            .overlay {
                                VStack(alignment: .leading){
                                    Spacer()
                                    Text(music).foregroundStyle(.white).padding()
                                        .font(.custom(Constants.TextConstants  .baloo2Bold, size: 18))
                                        .shadow(color: .black, radius: 20)
                                }.frame(width: 150, alignment: .leading)
                            }
                    }
                }
            }
           
        }.padding(.horizontal)
        
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


