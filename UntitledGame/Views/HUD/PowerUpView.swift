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
    @StateObject var gameScene: GameScene =  GameScene.shared
    let powerUp: [String] = ["more_dmg", "more_firerate", "more_hp", "more_speed", "more_bullet_speed"]
    @State var powerUpSet: Set = [0,1,2,3,4]
    @State var p1: Int = 0
    @State var p2: Int = 0
    @State var p3: Int = 0
    
    var body: some View {
        VStack{
            Text("Level Up!")
                .font(.custom ("Silkscreen-Bold", size: 40))
                .tracking(-2.5)
            
            ZStack{
                Image("cpuHor")
                    .interpolation(.none)
                    .resizable()
                    .frame(width:475, height:300)
                
                
                HStack{
                    //TODO: randomly sort powerUp + give it to player on tap
                  
                    
                    PixelArtButtonView(buttonImage: "PowerUpButton1", pressedImage: "PowerUpButton2", buttonPressedAction: {
                        gameLogic.showPowerUp = false
                        gameScene.callPowerUp(name: powerUp[p1])
                    }, textView: Text(powerUp[p1]) .font(.custom("Silkscreen-Regular", size: 20)), textColor: .white)
                    .tracking(-3)
                    .frame(width:94, height: 120)
                    
                    PixelArtButtonView(buttonImage: "PowerUpButton1", pressedImage: "PowerUpButton2", buttonPressedAction: {
                        gameLogic.showPowerUp = false
                        gameScene.callPowerUp(name: powerUp[p2])
                    }, textView: Text(powerUp[p2]) .font(.custom("Silkscreen-Regular", size: 20)), textColor: .white)
                    .tracking(-3)
                    .frame(width:94, height: 120)
                    .padding(.horizontal)
                    
                    PixelArtButtonView(buttonImage: "PowerUpButton1", pressedImage: "PowerUpButton2", buttonPressedAction: {
                        gameLogic.showPowerUp = false
                        gameScene.callPowerUp(name: powerUp[p3])
                    }, textView: Text(powerUp[p3]) .font(.custom("Silkscreen-Regular", size: 20)), textColor: .white)
                    .tracking(-3)
                    .frame(width:94, height: 120)
                    
                    
                    
                }.onAppear(){
                    p1 = powerUpSet.randomElement()!
                    powerUpSet.remove(p1)
                    p2 = powerUpSet.randomElement()!
                    powerUpSet.remove(p2)
                    p3 = powerUpSet.randomElement()!
                    powerUpSet.remove(p3)
                }
            }
        }
    }
}
#Preview {
    PowerUpView()
}
