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
    @State var showTutorial: Bool = false
    
    class AudioPlayer {
        static var shared: AVAudioPlayer = AVAudioPlayer()
    }
    
    var audioPlayer: AudioPlayer =  AudioPlayer()
    
    var body: some View {
        ZStack{
            Color.deadBlue.ignoresSafeArea()
            
            Image("chip3")
                .interpolation(.none)
                .scaledToFill()
                .ignoresSafeArea()
                .opacity(0.6)
            
            VStack{
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
                .padding(.bottom, 50)
                
                PixelArtButtonView(buttonImage: "ButtonPlay1", pressedImage: "ButtonPlay2",buttonPressedAction: {
                    withAnimation{
                        self.currentGameState = .chooseChar
                    }
                }, textView: Text("Play") .font(.custom("Silkscreen-Regular", size: 50)), textColor: .white)
                .frame(width: 224, height:96)
                .padding(.bottom, -30)
                .shadow(radius: 15)
                
                Group {
                    PixelArtButtonView(buttonImage: "ButtonSett1", pressedImage: "ButtonSett2", buttonPressedAction: {
                        showTutorial = true
                    }, textView: Text("Tutorial").font(.custom("Silkscreen-Regular", size: 25)), textColor: .white)
                    .fullScreenCover(isPresented: $showTutorial, content: {
                        TutorialMenu()
                    })
                    .frame(width: 224, height: 60)
                    .padding(.bottom, 10)
                    //                .offset(y: -20)
                    
                    PixelArtButtonView(buttonImage: "ButtonSett1", pressedImage: "ButtonSett2", buttonPressedAction: {
                        showSetting = true
                    }, textView: Text("Settings").font(.custom("Silkscreen-Regular", size: 25)), textColor: .white)
                    .fullScreenCover(isPresented: $showSetting, content: {
                        Settings_Menu(gameLogic: GameLogic.shared, switchMusic: $gameLogic.musicSwitch, switchSound: $gameLogic.soundsSwitch, music: $gameLogic.musicVolume, sounds: $gameLogic.soundsVolume)
                    })
                    .frame(width: 224, height: 60)
                    //                .offset(y: -20)
                }.offset(y: 80)
                
                
            }
            .padding(.top, 0)
        }.onAppear(perform: {
            if gameLogic.musicSwitch {
                do {
                    let path = Bundle.main.url(forResource: "mainmenu", withExtension: "mp3")
                    MainMenuView.AudioPlayer.shared = try AVAudioPlayer(contentsOf: path!)
                    MainMenuView.AudioPlayer.shared.numberOfLoops = -1
                    MainMenuView.AudioPlayer.shared.volume = 0.3
                    MainMenuView.AudioPlayer.shared.play()
                }
                catch {
                    
                }
            }
        }).onDisappear(perform: {
            MainMenuView.AudioPlayer.shared.stop()
        })
        .onChange(of: gameLogic.musicSwitch,perform: {
            value in
            if(gameLogic.musicSwitch){
                MainMenuView.AudioPlayer.shared.volume = (0.3/5)*Float(gameLogic.musicVolume)
            }else{
                MainMenuView.AudioPlayer.shared.volume = 0
            }
            
        })
        .onChange(of: gameLogic.musicVolume,perform: {
            value in
            if(gameLogic.musicSwitch){
                MainMenuView.AudioPlayer.shared.volume = (0.3/5)*Float(gameLogic.musicVolume)
            }
        })

        .statusBarHidden(true)
    }
    
    private func startGame() {
        print("restart")
        self.currentGameState = .playing
        
    }
}


#Preview {
    MainMenuView(currentGameState: .constant(GameState.mainScreen))
}
