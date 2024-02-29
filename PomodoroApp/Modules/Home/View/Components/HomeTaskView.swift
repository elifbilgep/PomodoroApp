//
//  HomeTaskView.swift
//  PomodoroApp
//
//  Created by Elif Parlak on 4.02.2024.
//

import SwiftUI

struct HomeTaskView: View {
    var task: TaskModel
    @AppStorage(UserDefaultsKey.currentTimerState.value) var currentTimerState: String?
    @AppStorage(UserDefaultsKey.currentTaskId.value) var currentTaskId: String?
    
    var body: some View {
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
                        Text(task.name).font(.custom(  Constants.TextConstants.baloo2Medium , size: 16))
                            .lineLimit(1)
                            .truncationMode(.tail)
                        HStack {
                            Text("\((task.duration).toInt()) Minutes" ).font(.custom(Constants.TextConstants.baloo2Medium, size: 16))
                                .foregroundStyle(.gray)
                        }
                    }
                    Spacer()
//                    currentTimerState == "focusing" && currentTaskId == task.taskId ?
                    NavigationLink(value: task) {
                        TaskStatusView(imageName: "startIcon", color: Color.greenTintColor)
                    }
//                    }.disabled(false-
//                    :
//                    NavigationLink(value: task) {
//                        TaskStatusView(imageName: "startIcon", color: Color.redTintColor)
//                    }.disabled(true)
                    
                    
                }.frame(width: 350, height: 40, alignment: .leading)
            }
    }
}

#Preview {
    HomeTaskView(task: Constants.fakeTaskModel)
}
