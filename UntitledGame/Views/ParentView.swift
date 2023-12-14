//
//  ParentView.swift
//  UntitledGame
//
//  Created by Linar Zinatullin on 07/12/23.
//

import SwiftUI
import AVFAudio

struct ParentView: View {
    
    class AudioPlayer {
        static var shared: AVAudioPlayer = AVAudioPlayer()
        static var shared2: AVAudioPlayer = AVAudioPlayer()
    }
    
    @State var currentGameState: GameState = .mainScreen
    
    @StateObject var gameLogic: GameLogic = GameLogic()
    
    var audioPlayer: AudioPlayer =  AudioPlayer()

    var body: some View {
        
        switch currentGameState {
        case .mainScreen: 
            MainMenuView(currentGameState: $currentGameState).onAppear(perform: {
                do {
                    let path = Bundle.main.url(forResource: "mainmenu", withExtension: "mp3")
                    ParentView.AudioPlayer.shared = try AVAudioPlayer(contentsOf: path!)
                    ParentView.AudioPlayer.shared.numberOfLoops = -1
                    ParentView.AudioPlayer.shared.play()
                }
                catch {
                    
                }
            }).onDisappear(perform: {
                ParentView.AudioPlayer.shared.stop()
            })
        case .playing:
            
            GameView()
                .environmentObject(gameLogic)
        case .gameOver:
            GameOverView()
        }
        
    }
}


#Preview {
    ParentView()
}
