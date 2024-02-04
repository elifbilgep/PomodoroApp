//
//  PomodoroButtonsView.swift
//  PomodoroApp
//
//  Created by Elif Parlak on 3.02.2024.
//

import SwiftUI

struct PomodoroButtonsView: View {
    @State var showAnimation = false
    var progressViewModel: ProgressViewModel
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        switch progressViewModel.progressModel.timerState {
        case .notStarted:
            CustomButton(color: Color("primaryColor"), title: "Start") {
                progressViewModel.startTimer()
            }
        case .focusing:
            VStack {
                CustomButton(color: Color("primaryColor"), title: "Pause") {
                    progressViewModel.stopTimer()
                }
                
                CustomButton(color: .red.opacity(0.5), title: "Give Up") {
                    progressViewModel.resetTimer()
                    removeAppStorage()
                    self.presentationMode.wrappedValue.dismiss()
                }
                
            }
            .opacity(showAnimation ? 1 : 0.3)
            .transition(.opacity)
                .onAppear {
                    withAnimation(.easeIn(duration: 1)) {
                        showAnimation = true
                    }
                }
            
        case .pause:
            VStack {
                CustomButton(color: Color("primaryColor"), title: "Resume") {
                    progressViewModel.resumeTimer()
                }
                
                CustomButton(color: .red.opacity(0.5), title: "Give Up") {
                    progressViewModel.resetTimer()
                    removeAppStorage()
                    self.presentationMode.wrappedValue.dismiss()
                    
                }
            }
        }
    }
    
    func removeAppStorage() {
        UserDefaults.standard.set(
            nil,
            forKey: "currentTimeValue")
        UserDefaults.standard.set(
            nil,
            forKey: "currentTaskId")
        UserDefaults.standard.set(
            nil,
            forKey: "currentState")
    }
}

#Preview {
    PomodoroButtonsView(progressViewModel: Constants.fakeProgressViewModel)
}
