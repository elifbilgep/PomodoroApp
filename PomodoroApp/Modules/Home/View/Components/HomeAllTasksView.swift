//
//  HomeAllTasksView.swift
//  PomodoroApp
//
//  Created by Elif Parlak on 4.02.2024.
//

import SwiftUI

struct HomeAllTasksView: View {
    @EnvironmentObject var homeViewModel: HomeViewModel
    var body: some View {
        VStack {
            Text("All Tasks")
                .font(.custom(Constants.TextConstants.baloo2SemiBold, size: 20))
                .foregroundColor(.black.opacity(0.6))
                .frame(width: 350, height: 20, alignment: .leading).padding()
            
            ForEach(homeViewModel.allTasks) { task in
                HomeTaskView(task: task)
            }
        }
    }
}

#Preview {
    HomeAllTasksView()
}
