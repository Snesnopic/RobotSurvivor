//
//  ContentView.swift
//  UntitledGame
//
//  Created by Giuseppe Francione on 05/12/23.
//

import SwiftUI
import SpriteKit

struct GameView: View {
    var scene: SKScene {
        let scene = GameScene()
        var screenWidth: CGFloat { UIScreen.main.bounds.size.width }
        var screenHeight: CGFloat { UIScreen.main.bounds.size.height }
        scene.size = CGSize(width: screenWidth, height: screenHeight)
        scene.scaleMode = .fill
        return scene
    }
    
    var body: some View {
        SpriteView(scene: self.scene)
                    .ignoresSafeArea()
    }
}

#Preview {
    GameView()
}
