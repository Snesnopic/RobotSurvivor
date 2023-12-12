//
//  ContentView.swift
//  UntitledGame
//
//  Created by Giuseppe Francione on 05/12/23.
//

import SwiftUI
import SpriteKit

struct GameViewUI: UIViewRepresentable {
     func makeUIView(context: Context) -> SKView {
         
        var screenWidth: CGFloat { UIScreen.main.bounds.size.width }
        var screenHeight: CGFloat { UIScreen.main.bounds.size.height }
        
        let view = SKView()
        let scene = GameScene()
        scene.size = CGSize(width: screenWidth, height: screenHeight)
        scene.scaleMode = .fill
        view.presentScene(scene)

        // Enable FPS and physics debugging
        view.showsFPS = true
        view.showsPhysics = true

        return view
    }

    func updateUIView(_ uiView: SKView, context: Context) {
    }

    typealias UIViewType = SKView
}


struct GameView: View {
    @State var x: Bool = false
    @StateObject var gameLogic: GameLogic =  GameLogic.shared
    private var sceneWrapper = SceneWrapper()

    var body: some View {
        ZStack {
            //GameViewUI()
            SpriteView(scene: self.sceneWrapper.scene)
                .onChange(of: gameLogic.showPowerUp){
                    sceneWrapper.scene.isPaused.toggle()
                }
                .ignoresSafeArea()
            SpriteView(scene: sceneWrapper.joystickScene,options: [.allowsTransparency])
                .onChange(of: gameLogic.showPowerUp){
                    sceneWrapper.joystickScene.isPaused.toggle()
                    if(gameLogic.showPowerUp == true){
                        sceneWrapper.joystickScene.hideJoystick()
                    }else{
                        sceneWrapper.joystickScene.showJoystick()
                    }
                }
                .ignoresSafeArea()
            ExpView(experienceNeeded: $gameLogic.xpToNextLvl ,currentXP: $gameLogic.currentXP)
            if(gameLogic.showPowerUp){
                PowerUpView()
            }
        }
    }
}

#Preview {
    GameView()
}
