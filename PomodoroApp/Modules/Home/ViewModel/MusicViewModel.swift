//
//  MusicViewModel.swift
//  PomodoroApp
//
//  Created by Elif Parlak on 6.03.2024.
//

import Foundation
import AVKit
import Observation
import SwiftUI

@Observable
class MusicViewModel {
    var audioPlayer: AVAudioPlayer?
    var selectedAudio: String
    var isAudioPlaying: Bool
    
    init() {
        if let sound = Bundle.main.path(forResource: "ocean_sound", ofType: "mp3") {
            do {
                self.audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound))
            } catch {
                print("AVAudioPlayer could not be instantiated.")
            }
        } else {
            print("Audio file could not be found.")
        }
        self.selectedAudio = ""
        self.isAudioPlaying = false
    }
    
    func setSound(selectedAudio: String) {
        self.selectedAudio = selectedAudio
        if let sound = Bundle.main.path(forResource: "\(selectedAudio)_sound", ofType: "mp3") {
            self.audioPlayer = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound))
        }
        
    }
    
    func playMusic() {
        self.audioPlayer?.play()
        withAnimation {
            self.isAudioPlaying = true
        }
        
    }
    
    func stopMusic() {
        self.audioPlayer?.stop()
    }
    
    func closeMusic() {
        withAnimation {
            self.isAudioPlaying = false
        }
    }
}

