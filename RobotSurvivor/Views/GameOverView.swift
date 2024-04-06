//
//  GameOverView.swift
//  UntitledGame
//
//  Created by Linar Zinatullin on 07/12/23.
//

import SwiftUI
import AVFAudio

struct GameOverView: View {
    
    @Binding var currentGameState: GameState
    @Binding var score:Int
    @State var opacity: Double = 0
    @StateObject var gameLogic: GameLogic = GameLogic.shared
    
    class AudioPlayer {
        static var shared: AVAudioPlayer = AVAudioPlayer()
    }
    
    var body: some View {
        ZStack{
            Color.darkGreen
                .ignoresSafeArea()
            VStack{
                Text("Game\nOver!")
                    .font(.custom("Silkscreen-Bold", size: 75))
                    .padding(.bottom, 100)
                    .multilineTextAlignment(.center)
                Text("Score: \(score)")
                    .font(.custom("Silkscreen-Bold", size: 30))
                    .padding(.bottom)
                PixelArtButtonView(buttonImage: "ButtonPlay1", pressedImage: "ButtonPlay2",buttonPressedAction: {
                    withAnimation {
                        restartGame()
                    }
                }, textView: Text("Restart") .font(.custom("Silkscreen-Regular", size: 35)), textColor: .white)
                .frame(width: 228, height:96)
                .padding(.top, 100)
                .shadow(radius: 15)
                
                PixelArtButtonView(buttonImage: "ButtonSett1", pressedImage: "ButtonSett2", buttonPressedAction: {
                    //TODO: add navigation to settings
                    withAnimation{ backToMainScreen()}
                }, textView: Text("Menu").font(.custom("Silkscreen-Regular", size: 25)), textColor: .white)
                .frame(width: 224, height:64)
                
            }
            .padding(.top, 50)
            .foregroundStyle(.green)
            
            
        }
        .opacity(opacity)
        .onAppear(perform: {
            withAnimation(.linear(duration: 1.3)){
                opacity = 1
            }
            
            if currentGameState == .gameOver {
                do {
                    let path = Bundle.main.url(forResource: "GAMEOVER", withExtension: "wav")
                    MainMenuView.AudioPlayer.shared = try AVAudioPlayer(contentsOf: path!)
                    MainMenuView.AudioPlayer.shared.numberOfLoops = 0
                    MainMenuView.AudioPlayer.shared.volume = gameLogic.soundsSwitch ? (0.2/5) * Float(gameLogic.soundsVolume) : 0
                    MainMenuView.AudioPlayer.shared.play()
                }
                catch {
                    print("Ascanio game over")
                }
            }
            GameOverView.AudioPlayer.shared.volume = gameLogic.musicSwitch ? (0.3/5)*Float(gameLogic.musicVolume) : 0
        })
        .onDisappear(perform: {
            GameOverView.AudioPlayer.shared.stop()
        })
        .background(.black)
    }
    
    private func backToMainScreen() {
        print("backtoMain")
        self.currentGameState = .mainScreen
        
    }
    
    private func restartGame() {
        print("restart")
        self.currentGameState = .playing
        
    }
}

#Preview("English") {
    GameOverView(currentGameState: .constant(GameState.gameOver), score: .constant(100))
        .environment(\.locale, Locale(identifier: "EN"))
}

#Preview("Italian") {
    GameOverView(currentGameState: .constant(GameState.gameOver), score: .constant(100))
        .environment(\.locale, Locale(identifier: "IT"))
}
