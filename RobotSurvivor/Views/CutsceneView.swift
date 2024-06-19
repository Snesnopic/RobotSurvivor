//
//  CutsceneView.swift
//  Robot Survivor
//
//  Created by Giuseppe Francione on 18/06/24.
//

import SwiftUI
import SpriteKit

struct CutsceneView: View {

    @Binding var currentGameState: GameState
    @ObservedObject var gameLogic: GameLogic =  GameLogic.shared
    @State var sceneWrapper = SceneWrapper.shared
    @State private var fadeTheView: Bool = false

    var body: some View {
        SpriteView(scene: self.sceneWrapper.cutscene)
            .ignoresSafeArea()
            .onAppear {
                self.gameLogic.restartGame()
            }
            .opacity(fadeTheView ? 0 : 1)
            .background(.black)
            .onChange(of: gameLogic.stage, perform: { _ in
                if gameLogic.stage == .main {
                    withAnimation {
                        currentGameState = .playing
                    }
                    sceneWrapper.scene.isPaused = false
                    sceneWrapper.scene.children.forEach { sknode in
                        print("Devo rimuovere")
                        if let enemy = sknode as? EnemyNode {
                            print("Rimuovo enemy")
                            enemy.removeFromParent()
                            enemy.removeAllActions()
                        }
                        if let name = sknode.name, name.contains("xp") {
                            print("Rimuovo xp")
                            sknode.removeAllActions()
                            sknode.removeFromParent()
                        }
                        if let name = sknode.name, name.contains("bullet") {
                            print("Rimuovo bullet")
                            sknode.removeAllActions()
                            sknode.removeFromParent()
                        }
                        if let name = sknode.name, name.contains("pickUp") {
                            print("Rimuovo pickUp")
                            sknode.removeAllActions()
                            sknode.removeFromParent()
                        }
                        sceneWrapper.scene.readyToSpawnPickUp = true
                        sceneWrapper.scene.enemiesOnMap = []
                    }

                }
            })
    }

    private func presentGameOverScreen() {
        self.currentGameState = .gameOver
    }

}

#Preview {
    CutsceneView(currentGameState: .constant(GameState.playing))
}
