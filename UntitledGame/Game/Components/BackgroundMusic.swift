//
//  BackgroundMusic.swift
//  UntitledGame
//
//  Created by Linar Zinatullin on 13/12/23.
//

import AVFoundation

extension GameScene: AVAudioPlayerDelegate{
    
    
    func setupBackgroundMusic(fileName: String) {
        
        //Forse il problema aveva a che fare col fatto che ci fosse una DispatchQueue globale che funzionava insieme alla DispatchQueue main, di conseguenza, quando si cambiava la canzone, poteva capitare che la GameScene deallocava fileName, da cui l'errore famoso
        DispatchQueue.main.async { [self] in
            guard let backgroundMusicURL = Bundle.main.url(forResource: fileName, withExtension: "mp3") else {
                DispatchQueue.main.async {
                    print("Could not find the music file.")
                }
                return
            }
            
            currentTrack = fileName
            do {
                let newPlayer = try AVAudioPlayer(contentsOf: backgroundMusicURL)
                newPlayer.numberOfLoops = 0
                newPlayer.prepareToPlay()
                newPlayer.delegate = self
                
                if(self.gameLogic.musicSwitch){
                    newPlayer.volume = (0.6/5)*Float(self.gameLogic.musicVolume)
                }else{
                    newPlayer.volume = 0
                }
                
                DispatchQueue.main.async {
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

