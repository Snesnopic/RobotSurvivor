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
        
        for _ in 0..<(quantityOfMusic) {
            do {
                let backgroundMusic = Bundle.main.url(forResource: "game\(index+1)", withExtension: "mp3")
                let song = try AVAudioPlayer(contentsOf: backgroundMusic!)
                song.numberOfLoops = 0
                song.prepareToPlay()
                musicPool.append(song)
                index += 1
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
        backgroundMusicPlayer = currentMusic
        musicPool.append(currentMusic!)
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        playTracks()
    }
    
    func stopTracks() {
        backgroundMusicPlayer?.stop()
        backgroundMusicPlayer = nil
    }
    
}
