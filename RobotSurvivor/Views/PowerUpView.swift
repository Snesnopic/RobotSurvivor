//
//  PowerUpView.swift
//  UntitledGame
//
//  Created by Giuseppe Casillo on 12/12/23.
//

import Foundation
import SwiftUI
import SpriteKit
import AVFAudio

struct PowerUpView: View {
    @StateObject var gameLogic: GameLogic = GameLogic.shared
    @Binding var sceneWrap: SceneWrapper
    let powerUpDisplayed: [String] = [String(localized: "dmg"), String(localized: "firerate"), String(localized: "hp"), String(localized: "speed"), String(localized: "bullet speed")]
    
    let powerUp: [String] = ["+dmg", "+firerate", "+hp", "+speed", "+bullet speed"]
    
    let path = Bundle.main.url(forResource: "LEVELUP", withExtension: "mp3")
    let speedControl = AVAudioUnitVarispeed()
    @State var powerUpSet: Set = [0,1,2,3,4]
    @State var p1: Int = 0
    @State var p2: Int = 0
    @State var p3: Int = 0
    
    class AudioPlayer {
        static var shared: AVAudioPlayer = AVAudioPlayer()
    }
    
    var body: some View {
        
        ZStack{
            Image("cpuPower")
                .interpolation(.none)
                .resizable()
                .offset(y:25)
                .frame(width: 370,height: 400)
            VStack{
                Text("Power Up!")
                    .font(.custom ("Silkscreen-Bold", size: 40))
                    .tracking(-2.5)
                    .foregroundStyle(.white)
                    .padding(.bottom, 50)
                
                
                HStack{
                    //TODO: randomly sort powerUp + give it to player on tap
                    
                    ZStack{
                        PixelArtButtonView(buttonImage: "PowerUpButton1", pressedImage: "PowerUpButton2", buttonPressedAction: {
                            gameLogic.showPowerUp = false
                            sceneWrap.scene.callPowerUp(name: powerUpDisplayed[p1])
                        }, imageView: Image(powerUp[p1]))
                    }
                    .frame(width:94, height: 120)
                                        
                    ZStack{
                        PixelArtButtonView(buttonImage: "PowerUpButton1", pressedImage: "PowerUpButton2", buttonPressedAction: {
                            gameLogic.showPowerUp = false
                            sceneWrap.scene.callPowerUp(name: powerUpDisplayed[p2])
                        }, imageView: Image(powerUp[p2]))
                        
                    }
                    .frame(width:94, height: 120)
                    .padding(.horizontal, 5)
                    
                    ZStack{ PixelArtButtonView(buttonImage: "PowerUpButton1", pressedImage: "PowerUpButton2", buttonPressedAction: {
                        gameLogic.showPowerUp = false
                        sceneWrap.scene.callPowerUp(name: powerUpDisplayed[p3])
                    }, imageView: Image(powerUp[p3]))
                            
                    }.frame(width:94, height: 120)
                    
                    
                    
                }
                .onAppear(){
                    p1 = powerUpSet.randomElement()!
                    powerUpSet.remove(p1)
                    p2 = powerUpSet.randomElement()!
                    powerUpSet.remove(p2)
                    p3 = powerUpSet.randomElement()!
                    powerUpSet.remove(p3)
                    DispatchQueue.main.async {
                        do {
                            
                            PowerUpView.AudioPlayer.shared = try AVAudioPlayer(contentsOf: path!)
                            PowerUpView.AudioPlayer.shared.numberOfLoops = 0
                            PowerUpView.AudioPlayer.shared.rate = 0.1
                            PowerUpView.AudioPlayer.shared.volume = gameLogic.musicSwitch ? (0.1/5) * Float(gameLogic.musicVolume) : 0
                        } catch {
                            print("Ascanio")
                        }
                    }
                }.onDisappear(perform: {
                    if gameLogic.musicSwitch {
                        PowerUpView.AudioPlayer.shared.play()
                    }
                })
                
                
                
                
                HStack(alignment: .top){
                    Text(String("+" + powerUpDisplayed[p1]))
                        .tracking(-3)
                        .frame(maxWidth: 94)
                    Text(String("+" + powerUpDisplayed[p2]))
                        .tracking(-3)
                        .frame(maxWidth: 94)
                        .padding(.horizontal, 5)
                    Text(String("+" + powerUpDisplayed[p3]))
                        .tracking(-3)
                        .frame(maxWidth: 94)
                }
                .font(.custom("Silkscreen-Regular", size: 20))
                .foregroundStyle(.white)
                .frame(height: 55)
                .padding(.top, -5)
            }
        }
    }
}

#Preview("English") {
    PowerUpView(sceneWrap: .constant(SceneWrapper()))
        .environment(\.locale, Locale(identifier: "EN"))
}

#Preview("Italian") {
    PowerUpView(sceneWrap: .constant(SceneWrapper()))
        .environment(\.locale, Locale(identifier: "IT"))
}
