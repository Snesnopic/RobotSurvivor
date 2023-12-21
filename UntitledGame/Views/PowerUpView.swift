//
//  PowerUpView.swift
//  UntitledGame
//
//  Created by Giuseppe Casillo on 12/12/23.
//

import Foundation
import SwiftUI
import SpriteKit

struct PowerUpView: View {
    @StateObject var gameLogic: GameLogic =  GameLogic.shared
    @Binding var sceneWrap: SceneWrapper
    let powerUp: [String] = ["+dmg", "+firerate", "+hp", "+speed", "+bullet speed"]
    @State var powerUpSet: Set = [0,1,2,3,4]
    @State var p1: Int = 0
    @State var p2: Int = 0
    @State var p3: Int = 0
    
    var body: some View {
        
            ZStack{
                Image("cpuPower")
                    .interpolation(.none)
                    .resizable()
                    .scaledToFit()
                    .offset(y:25)
                    .padding(.horizontal, 10)
                
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
                                    sceneWrap.scene.callPowerUp(name: powerUp[p1])
                                }, imageView: Image(powerUp[p1]))
                            }
                            .frame(width:94, height: 120)

                        
                        
                        ZStack{
                            PixelArtButtonView(buttonImage: "PowerUpButton1", pressedImage: "PowerUpButton2", buttonPressedAction: {
                                gameLogic.showPowerUp = false
                                sceneWrap.scene.callPowerUp(name: powerUp[p2])
                            }, imageView: Image(powerUp[p2]))
                            
                        }
                        .frame(width:94, height: 120)
                        .padding(.horizontal, 5)
                        
                        ZStack{ PixelArtButtonView(buttonImage: "PowerUpButton1", pressedImage: "PowerUpButton2", buttonPressedAction: {
                            gameLogic.showPowerUp = false
                            sceneWrap.scene.callPowerUp(name: powerUp[p3])
                        }, imageView: Image(powerUp[p3]))
                        
                            
                            
                        }.frame(width:94, height: 120)
                        
                        
                        
                    }.onAppear(){
                        p1 = powerUpSet.randomElement()!
                        powerUpSet.remove(p1)
                        p2 = powerUpSet.randomElement()!
                        powerUpSet.remove(p2)
                        p3 = powerUpSet.randomElement()!
                        powerUpSet.remove(p3)
                    }
                    
                    
                    HStack(alignment: .top){
                        Text(powerUp[p1])
                            .frame(maxWidth: 94)
                        Text(powerUp[p2])
                            .frame(maxWidth: 94)
                            .padding(.horizontal, 5)
                        Text(powerUp[p3])
                            .frame(maxWidth: 94)
                    }
                    .font(.custom("Silkscreen-Regular", size: 20))
                    .foregroundStyle(.white)
                    .tracking(-3)
                    .frame(height: 55)
                    .padding(.top, -5)
                    
                    
                }
            }
        }
    }

#Preview {
    PowerUpView(sceneWrap: .constant(SceneWrapper()))
}
