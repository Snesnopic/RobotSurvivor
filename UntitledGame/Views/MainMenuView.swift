//
//  NewMainMenuView.swift
//  UntitledGame
//
//  Created by Maya Navarrete Moncada on 13/12/23.
//

import SwiftUI

struct MainMenuView: View {
    @StateObject var gameLogic: GameLogic =  GameLogic.shared
    @Binding var currentGameState: GameState
    @State var showSetting: Bool = false
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
