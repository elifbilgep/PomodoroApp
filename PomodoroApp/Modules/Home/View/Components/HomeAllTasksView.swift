//
//  HomeAllTasksView.swift
//  PomodoroApp
//
//  Created by Elif Parlak on 4.02.2024.
//

import SwiftUI
import SwiftData

struct HomeAllTasksView: View {
    var homeViewModel: HomeViewModel
    
    var body: some View {
        VStack {
            HStack {
                Text("All Tasks")
                    .font(.custom(Constants.TextConstants.baloo2SemiBold, size: 20))
                    .foregroundColor(.black.opacity(0.6))
                    .frame(width: 300, height: 20, alignment: .leading).padding()
                Spacer()
               
            }
            
            ForEach(homeViewModel.allTasks) { task in
                HomeTaskView(task: task)
            }
        }

    }
}

#Preview {
    let fakePVM = Constants.fakeProgressViewModel
  return  HomeAllTasksView(homeViewModel: HomeViewModel())
}
