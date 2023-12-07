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
        scene.size = CGSize(width: 216, height: 216)
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
