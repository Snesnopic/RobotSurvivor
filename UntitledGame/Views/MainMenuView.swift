//
//  NewMainMenuView.swift
//  UntitledGame
//
//  Created by Maya Navarrete Moncada on 13/12/23.
//

import SwiftUI
import AVFoundation

struct MainMenuView: View {
    
    @StateObject var gameLogic: GameLogic =  GameLogic.shared
    @Binding var currentGameState: GameState
    @State var showSetting: Bool = false
    
    class AudioPlayer {
        static var shared: AVAudioPlayer = AVAudioPlayer()
    }
    
    var audioPlayer: AudioPlayer =  AudioPlayer()
    
    var body: some View {
        ZStack{
            Color.deadBlue
                .ignoresSafeArea()
            
            Image("chip3")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
                .offset(x: -34)
                .opacity(0.6)
                
            
            
            VStack{
                
                Spacer()
                
                ZStack{
                    Image("cpuHor")
                        .interpolation(.none)
                        .resizable()
                        .frame(width: 315,height: 230)
                        .padding(.bottom, 25)
                        .shadow(radius: 15)
                    
                    VStack{
                        Text("Robot")
                            .font(.custom("Silkscreen-Bold", size: 50))
                            .foregroundStyle(.white)
                        Text("Survivor")
                            .font(.custom("Silkscreen-Bold", size: 30))
                            .foregroundStyle(.white)
                            .padding(.top, -45)
                            .padding(.bottom, 30)
                    }
                    
                }
                
                
                PixelArtButtonView(buttonImage: "ButtonPlay1", pressedImage: "ButtonPlay2",buttonPressedAction: {
                    //TODO: add navigation to game
                    withAnimation{startGame()}
                }, textView: Text("Play") .font(.custom("Silkscreen-Regular", size: 50)), textColor: .white)
                .frame(width: 224, height:96)
                .padding(.bottom)
                .shadow(radius: 15)
                
                
                PixelArtButtonView(buttonImage: "ButtonSett1", pressedImage: "ButtonSett2", buttonPressedAction: {
                    showSetting = true
                    }, textView: Text("Settings").font(.custom("Silkscreen-Regular", size: 25)), textColor: .white)
                .fullScreenCover(isPresented: $showSetting, content: {
                    Settings_Menu(switchMusic: $gameLogic.musicSwitch, switchSound: $gameLogic.soundsSwitch, music: $gameLogic.musicVolume, sounds: $gameLogic.soundsVolume)
                })
                .frame(width: 224, height:64)
                
                Spacer()
                
            }
        }.onAppear(perform: {
            do {
                let path = Bundle.main.url(forResource: "mainmenu", withExtension: "mp3")
                MainMenuView.AudioPlayer.shared = try AVAudioPlayer(contentsOf: path!)
                MainMenuView.AudioPlayer.shared.numberOfLoops = -1
                MainMenuView.AudioPlayer.shared.volume = 0.3
                MainMenuView.AudioPlayer.shared.play()
            }
            catch {
                
            }
        }).onDisappear(perform: {
            MainMenuView.AudioPlayer.shared.stop()
        })
        .onChange(of: gameLogic.musicSwitch){
            if(gameLogic.musicSwitch){
                MainMenuView.AudioPlayer.shared.volume = (0.3/5)*Float(gameLogic.musicVolume)
            }else{
                MainMenuView.AudioPlayer.shared.volume = 0
            }
            
        }
        .onChange(of: gameLogic.musicVolume){
            if(gameLogic.musicSwitch){
                MainMenuView.AudioPlayer.shared.volume = (0.3/5)*Float(gameLogic.musicVolume)
            }
        }
    }
    
    private func startGame() {
        print("restart")
        self.currentGameState = .playing
        
    }
}


#Preview {
    MainMenuView(currentGameState: .constant(GameState.mainScreen))
}
