//
//  BackgroundMusic.swift
//  UntitledGame
//
//  Created by Linar Zinatullin on 13/12/23.
//

import AVFoundation

extension GameScene: AVAudioPlayerDelegate{
    
    
    func setupBackgroundMusic(fileName: String) {
        DispatchQueue.global(qos: .userInitiated).async {
            guard let backgroundMusicURL = Bundle.main.url(forResource: fileName, withExtension: "mp3") else {
                DispatchQueue.main.async {
                    print("Could not find the music file.")
                }
                return
            }
            
            self.currentTrack = fileName
            do {
                let newPlayer = try AVAudioPlayer(contentsOf: backgroundMusicURL)
                newPlayer.numberOfLoops = 0
                newPlayer.prepareToPlay()
                newPlayer.delegate = self
                
                if(self.gameLogic.musicSwitch){
                    newPlayer.volume = (0.3/5)*Float(self.gameLogic.musicVolume)
                }else{
                    newPlayer.volume = 0
                }
                
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
    
    func playTracks(){
        setupBackgroundMusic(fileName: "game1")
        backgroundMusicPlayer?.play()
        
    }
    
    func determineNextTrack() -> String{
        switch currentTrack{
            case "game1":
                return "game2"
            case "game2":
                return "game1"
        default:
            return "game1"
        }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag {
            let nextTrack = determineNextTrack()
            setupBackgroundMusic(fileName: nextTrack)
            backgroundMusicPlayer?.play()
        }
    }
    
    func stopTracks(){
        backgroundMusicPlayer?.stop()
    }

}

