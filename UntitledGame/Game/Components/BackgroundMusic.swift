//
//  BackgroundMusic.swift
//  UntitledGame
//
//  Created by Linar Zinatullin on 13/12/23.
//

import AVFoundation

extension GameScene{
    
    
    func setupBackgroundMusic(fileName: String) {
        DispatchQueue.global(qos: .userInitiated).async {
            guard let backgroundMusicURL = Bundle.main.url(forResource: fileName, withExtension: "mp3") else {
                DispatchQueue.main.async {
                    print("Could not find the music file.")
                }
                
                return
            }
            
            
            do {
                let newPlayer = try AVAudioPlayer(contentsOf: backgroundMusicURL)
                newPlayer.numberOfLoops = -1
                newPlayer.prepareToPlay()
                
                DispatchQueue.main.async {
                    if self.backgroundMusicPlayer != nil {
                        self.backgroundMusicPlayer?.stop()
                    }
                    self.backgroundMusicPlayer = newPlayer
                    self.backgroundMusicPlayer?.play()
                }
            } catch {
                DispatchQueue.main.async {
                    print("Could not create audio player: \(error)")
                }
            }
        }
    }
    func changeTrack(to newTrack: String) {
         setupBackgroundMusic(fileName: newTrack)
        backgroundMusicPlayer?.play()
    }
}

