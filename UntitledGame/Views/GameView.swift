//
//  ContentView.swift
//  UntitledGame
//
//  Created by Giuseppe Francione on 05/12/23.
//

import SwiftUI
import SpriteKit

struct GameView: View {
    @StateObject var gameLogic: GameLogic =  GameLogic.shared
    var scene: GameScene
    var joystickScene: Joystick
    init() {
        var screenWidth: CGFloat { UIScreen.main.bounds.size.width }
        var screenHeight: CGFloat { UIScreen.main.bounds.size.height }
        
        scene = GameScene()
        scene.size = CGSize(width: screenWidth, height: screenHeight)
        scene.scaleMode = .fill
        joystickScene = Joystick(player: scene.player)
        joystickScene.size = CGSize(width: screenWidth, height: screenHeight)
    }

    var body: some View {
        ZStack {
            SpriteView(scene: self.scene)
                .ignoresSafeArea()
            SpriteView(scene: joystickScene,options: [.allowsTransparency]).ignoresSafeArea()
            ExpView(experienceNeeded: $gameLogic.xpToNextLvl ,currentXP: $gameLogic.currentXP)
        }
        
    }
}

#Preview {
    GameView()
}
