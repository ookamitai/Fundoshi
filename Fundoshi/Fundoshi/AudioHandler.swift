//
//  AudioHandler.swift
//  FormantBuilder
//
//  Created by ookamitai on 8/9/24.
//

import Foundation
import AVFoundation

class AudioHandler {
    var audioPlayer: AVAudioPlayer?
    
    func playSound(_ path: String) {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: URL(filePath: path))
            audioPlayer?.play()
        } catch {
            print("error in audio play")
        }
    }
}
