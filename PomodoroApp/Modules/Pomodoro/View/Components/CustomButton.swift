//
//  CustomButton.swift
//  PomodoroApp
//
//  Created by Elif Bilge Parlak on 29.12.2023.
//
//resume iken çıkınca girdiğimde state focusing oluyo

import SwiftUI

struct CustomButton: View {
    var gradient: LinearGradient?
    var color: Color
    var title: String
    var onTap: () -> Void
    
    var body: some View {
        RoundedRectangle(cornerRadius: 20)
            .foregroundStyle(color)
            .overlay {
                Text(title)
            }
            .frame(width: 300,height: 60)
            .font(.custom(Constants.TextConstants.baloo2Medium, size: 18))
            .foregroundStyle(.white)
            .onTapGesture(perform: onTap)
    }
}
