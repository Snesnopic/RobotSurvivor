//
//  BackgroundMusic.swift
//  UntitledGame
//
//  Created by Linar Zinatullin on 13/12/23.
//

import AVFoundation

extension GameScene: AVAudioPlayerDelegate{
    
    
    func setupBackgroundMusic(quantityOfMusic: Int) {
        var index: Int = 0
    //Forse il problema aveva a che fare col fatto che ci fosse una DispatchQueue globale che funzionava insieme alla DispatchQueue main, di conseguenza, quando si cambiava la canzone, poteva capitare che la GameScene deallocava fileName, da cui l'errore famoso
        
        for _ in 0..<(quantityOfMusic) {
            do {
                let backgroundMusic = Bundle.main.url(forResource: "game\(index+1)", withExtension: "mp3")
                let song = try AVAudioPlayer(contentsOf: backgroundMusic!)
                song.numberOfLoops = 0
                song.prepareToPlay()
                musicPool.append(song)
                index += 1
//                newPlayer.numberOfLoops = 0
//                newPlayer.prepareToPlay()
//                newPlayer.delegate = self
//                newPlayer.volume = self.gameLogic.musicSwitch ? (0.6/5) * Float(self.gameLogic.musicVolume) : 0

//                DispatchQueue.main.async { [self] in
//                    self.backgroundMusicPlayer = newPlayer
//                    self.backgroundMusicPlayer?.play()
//                }
            } catch {
                print("Could not create audio player: \(error)")
            }
        }
    }
    //haha scemo
    func playTracks() {
        guard !gameLogic.isGameOver else { return }
        let currentMusic = musicPool.first
        musicPool.removeFirst()
        currentMusic?.volume = gameLogic.soundsSwitch ? (0.6/5) * Float(gameLogic.soundsVolume) : 0
        currentMusic?.play()
        currentMusic?.delegate = self
        musicPool.append(currentMusic!)
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        playTracks()
    }
}
