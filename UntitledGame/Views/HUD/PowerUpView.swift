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
        HStack{
            //TODO: randomly sort powerUp + give it to player on tap
            Button(action: {
                gameLogic.showPowerUp = false
                gameScene.callPowerUp(name: powerUp[p1])
                
            }, label: {
                ZStack{
                    Rectangle().frame(width: 100, height: 100).foregroundStyle(.green)
                    Text(powerUp[p1])
                }
            })
            Button(action: {
                gameLogic.showPowerUp = false
                gameScene.callPowerUp(name: powerUp[p2])
            }, label: {
                ZStack{
                    Rectangle().frame(width: 100, height: 100).foregroundStyle(.green)
                    Text(powerUp[p2])
                }
            }).padding(.horizontal)
            Button(action: {
                gameLogic.showPowerUp = false
                gameScene.callPowerUp(name: powerUp[p3])
            }, label: {
                ZStack{
                    Rectangle().frame(width: 100, height: 100).foregroundStyle(.green)
                    Text(powerUp[p3])
                }
            })
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
#Preview {
    PowerUpView()
}
