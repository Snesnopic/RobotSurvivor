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

    @Binding var currentGameState: GameState
    @ObservedObject var gameLogic: GameLogic = GameLogic.shared
    @State var sceneWrapper = SceneWrapper.shared
    @State private var fadeTheView: Bool = false

    var body: some View {
        ZStack {

            SpriteView(scene: self.sceneWrapper.scene)
                .onChange(of: gameLogic.stage, perform: { _ in
                    withAnimation {
                        if gameLogic.stage == .cutscene {
                            sceneWrapper.scene.isPaused = true
                            currentGameState = .cutscene
                        }
                    }
                })
                .onChange(of: gameLogic.showPowerUp, perform: { _ in
                    if gameLogic.showPowerUp == false {
                        sceneWrapper.scene.isPaused = false
                    }
                })
                .onChange(of: gameLogic.showPauseMenu, perform: { _ in
                    if gameLogic.showPauseMenu == false {
                        sceneWrapper.scene.isPaused = false
                    }
                })

                .onChange(of: gameLogic.showTutorial, perform: { _ in
                    if gameLogic.showTutorial == false {
                        sceneWrapper.scene.isPaused = false
                    }
                })
                .ignoresSafeArea()

            SpriteView(scene: sceneWrapper.joystickScene, options: [.allowsTransparency])
                .onChange(of: gameLogic.showPowerUp, perform: { _ in
                    if gameLogic.showPowerUp == false {
                        sceneWrapper.joystickScene.isPaused = false
                    } else {
                        sceneWrapper.joystickScene.isPaused = true
                    }

                    if gameLogic.showPowerUp == true {
                        sceneWrapper.joystickScene.hideJoystick()
                    } else {
                        sceneWrapper.joystickScene.showJoystick()
                    }
                })
                .onChange(of: gameLogic.showPauseMenu, perform: { _ in
                    if gameLogic.showPauseMenu == false {
                        sceneWrapper.joystickScene.isPaused = false
                    } else {
                        sceneWrapper.joystickScene.isPaused = true
                    }

                    if gameLogic.showPauseMenu == true {
                        sceneWrapper.joystickScene.hideJoystick()
                    } else {
                        sceneWrapper.joystickScene.showJoystick()
                    }
                })
                .ignoresSafeArea()

                .onChange(of: gameLogic.showTutorial, perform: { _ in
                    if gameLogic.showTutorial == true {
                        sceneWrapper.joystickScene.isPaused = true
                    } else {
                        sceneWrapper.joystickScene.isPaused = false
                    }

                    if gameLogic.showTutorial == false {
                        sceneWrapper.joystickScene.showJoystick()
                    } else {
                        sceneWrapper.joystickScene.hideJoystick()
                    }
                })

            ExpView()

            ScoreView()
                .padding(.vertical)

            if gameLogic.showPowerUp {
                PowerUpView(sceneWrap: $sceneWrapper)
            }
            if gameLogic.showPauseMenu {
                PauseMenuView(gameLogic: gameLogic, currentGameState: $currentGameState, sceneWrap: $sceneWrapper)
            }

            if gameLogic.showTutorial {
                TutorialView(gameLogic: gameLogic, currentGameState: $currentGameState, sceneWrap: $sceneWrapper)
            }
        }
        .onChange(of: sceneWrapper.scene.isPlayerAlive, perform: { _ in
            withAnimation(.linear(duration: 0.95).delay(1.55)) {
                self.fadeTheView = true
            }
        })

        .onChange(of: gameLogic.isGameOver, perform: { _ in

            if gameLogic.isGameOver {

                self.presentGameOverScreen()

            }
        })
        .opacity(fadeTheView ? 0 : 1)
        .background(.black)
    }

    private func presentGameOverScreen() {
        self.currentGameState = .gameOver
    }

}

#Preview {
    GameView(currentGameState: .constant(GameState.playing))
}
