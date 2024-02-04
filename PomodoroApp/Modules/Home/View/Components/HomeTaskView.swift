//
//  HomeTaskView.swift
//  PomodoroApp
//
//  Created by Elif Parlak on 4.02.2024.
//

import SwiftUI

struct HomeTaskView: View {
    var task: TaskModel
    var userDefaultsManager = UserDefaultManager.shared
    
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
                    if userDefaultsManager.get(for: .currentTaskId) != nil {
                        if userDefaultsManager.get(for: .currentTaskId) == task.taskId {
                            NavigationLink(value: task) {
                                TaskStatusView(imageName: "startIcon", color: Color.greenTintColor)
                            }
                        } else {
                            TaskStatusView(imageName: "noEnterIcon", color: Color.redTintColor)
                        }
                    } else {
                        NavigationLink(value: task) {
                            TaskStatusView(imageName: "startIcon", color: Color.greenTintColor)
                        }
                    }
                    
                }.frame(width: 350, height: 40, alignment: .leading)
            }
    }
}

#Preview {
    HomeTaskView(task: Constants.fakeTaskModel)
}
