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
    var scene: GameScene
    var joystickScene: Joystick
    init() {
        var screenWidth: CGFloat { UIScreen.main.bounds.size.width }
        var screenHeight: CGFloat { UIScreen.main.bounds.size.height }
        
        scene = GameScene()
        scene.size = CGSize(width: screenWidth, height: screenHeight)
        scene.scaleMode = .fill
        joystickScene = Joystick(player: scene.player,gameSceneReference: scene)
        joystickScene.size = CGSize(width: screenWidth, height: screenHeight)
    }
    var body: some View {
        ZStack {
            //GameViewUI()
            SpriteView(scene: self.scene).ignoresSafeArea()
            SpriteView(scene: joystickScene,options: [.allowsTransparency]).ignoresSafeArea()
        }
        
    }
}

#Preview {
    GameView()
}
