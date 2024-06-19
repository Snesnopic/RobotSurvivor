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
    @StateObject var gameLogic: GameLogic =  GameLogic.shared
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
    }

    private func presentGameOverScreen() {
        self.currentGameState = .gameOver
    }

}

#Preview {
    CutsceneView(currentGameState: .constant(GameState.playing))
}
