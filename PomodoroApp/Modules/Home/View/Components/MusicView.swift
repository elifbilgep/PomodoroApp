//
//  MusicView.swift
//  PomodoroApp
//
//  Created by Elif Parlak on 5.03.2024.
//

import SwiftUI
import AVKit

struct MusicView: View {
    private let musicList = ["ocean", "forest", "night", "rain", "thunderstorm"]
    var musicViewModel: MusicViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Calm Sounds")
                .font(.custom(Constants.TextConstants.baloo2SemiBold, size: 20))
                .foregroundColor(.black.opacity(0.6))
                .frame(width: 300, height: 20, alignment: .leading)
                .padding(.horizontal)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(musicList, id: \.self ) { music in
                        Image(music)
                            .resizable()
                            .scaledToFit()
                            .cornerRadius(10)
                            .frame(width: 150, height: 200)
                            .overlay {
                                VStack(alignment: .leading){
                                    Spacer()
                                    Text(music)
                                        .foregroundStyle(.white).padding()
                                        .font(.custom(Constants.TextConstants  .baloo2Bold, size: 18))
                                        .shadow(color: .black, radius: 20)
                                }.frame(width: 150, alignment: .leading)
                            }.onTapGesture {
                                musicViewModel.setSound(selectedAudio: music)
                                musicViewModel.playMusic()
                            }
                    }
                }.padding(.leading)
            }
        }.frame(height: 250)
    }
}

#Preview {
    MusicView(musicViewModel: MusicViewModel())
}
