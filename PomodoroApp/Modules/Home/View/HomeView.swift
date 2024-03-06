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
    private var musicViewModel = MusicViewModel()
    
    //MARK: - Body
    @ViewBuilder
    var body: some View {
        NavigationStack(path: $homeViewModel.path) {
            ZStack() {
                Color.bgColor
                ScrollView {
                    VStack {
                        headlineView()
                        musicPlayerView()
                        HomeTextFieldView(
                            isAddTaskSheetOpen: $homeViewModel.isAddTaskSheetOpen,
                            textFieldText: $homeViewModel.textFieldText,
                            isPresented: $homeViewModel.isPresented,
                            homeViewModel: homeViewModel)
                        MusicView(musicViewModel: musicViewModel)
                        HomeAllTasksView(homeViewModel: homeViewModel)
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
    
    @ViewBuilder  
    private func musicPlayerView() -> some View {
        musicViewModel.isAudioPlaying ?
        Rectangle()
            .frame(width: 350, height: 60)
            .foregroundStyle(.white)
            .cornerRadius(20)
            .overlay {
                HStack {
                    Image(musicViewModel.selectedAudio)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40)
                        .cornerRadius(10)
                    VStack(alignment: .leading) {
                        Text(musicViewModel.selectedAudio)
                            .font(.custom(Constants.TextConstants.baloo2Medium, size: 18))
                        HStack {
                            Image(systemName: "play.fill").onTapGesture {
                                musicViewModel.playMusic()
                            }
                            Image(systemName: "stop.fill").onTapGesture {
                                musicViewModel.stopMusic()
                            }
                        }
                    }
                    Spacer()
                    Image(systemName: "xmark")
                        .onTapGesture {
                            musicViewModel.closeMusic()
                        }
                } .padding(.all, 10)
            }
            .frame(width: UIScreen.screenWidth, height: 60)
        : nil
    }
    
    @ViewBuilder
    private func headlineView() -> some View {
        HStack {
            VStack (alignment: .leading, spacing: -10) {
                Text("Welcome")
                    .font(.custom(Constants.TextConstants.baloo2SemiBold, size: 28))
                Text("Be productive today!")
                    .font(.custom(Constants.TextConstants.baloo2Medium, size: 20))
                    .font(.system(size: 20))
                    .foregroundColor(.black.opacity(0.6))
                
            }.frame(width: UIScreen.screenWidth - 70, height: 60,alignment: .leading)
            Image(systemName: "text.alignright")
        }.padding()
    }
}

//MARK: - Preview
#Preview {
    HomeView()
}


