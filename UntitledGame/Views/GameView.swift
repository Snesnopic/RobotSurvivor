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
    
    @State var x: Bool = false
    @StateObject var gameLogic: GameLogic =  GameLogic.shared
    @State var sceneWrapper = SceneWrapper()
    
    
    
    var body: some View {
        ZStack {
            GameViewUI()
            SpriteView(scene: self.sceneWrapper.scene)
                .onChange(of: gameLogic.showPowerUp){
                    if(gameLogic.showPowerUp == false){
                        sceneWrapper.scene.isPaused = false
                    }
                }
                .onChange(of: gameLogic.showPauseMenu){
                    if(gameLogic.showPauseMenu == false){
                        sceneWrapper.scene.isPaused = false
                    }
                }
                .ignoresSafeArea()
            
            SpriteView(scene: sceneWrapper.joystickScene,options: [.allowsTransparency])
                .onChange(of: gameLogic.showPowerUp){
                    if(gameLogic.showPowerUp == false){
                        sceneWrapper.joystickScene.isPaused = false
                    }else{
                        sceneWrapper.joystickScene.isPaused = true
                    }
                    
                    if(gameLogic.showPowerUp == true){
                        sceneWrapper.joystickScene.hideJoystick()
                    }else{
                        sceneWrapper.joystickScene.showJoystick()
                    }
                }
                .onChange(of: gameLogic.showPauseMenu){
                    if(gameLogic.showPauseMenu == false){
                        sceneWrapper.joystickScene.isPaused = false
                    }else{
                        sceneWrapper.joystickScene.isPaused = true
                    }
                    
                    if(gameLogic.showPauseMenu == true){
                        sceneWrapper.joystickScene.hideJoystick()
                    }else{
                        sceneWrapper.joystickScene.showJoystick()
                    }
                }
                .ignoresSafeArea()
            
            ExpView(experienceNeeded: $gameLogic.xpToNextLvl ,currentXP: $gameLogic.currentXP)
            
            ScoreView(score: $gameLogic.currentScore)
            DurationView(time: $gameLogic.time)
            
            if(gameLogic.showPowerUp){
                PowerUpView(sceneWrap: $sceneWrapper)
            }
            if(gameLogic.showPauseMenu){
                PauseMenuView(gameLogic: gameLogic ,currentGameState: $currentGameState, sceneWrap: $sceneWrapper);
            }
            
            
            
        }.onChange(of: gameLogic.isGameOver){
            if gameLogic.isGameOver {
                /** # PRO TIP!
                 * You can experiment by adding other types of animations here before presenting the game over screen.
                 */
                
                    self.presentGameOverScreen()
            }
            
        }
        .onAppear{
            self.gameLogic.restartGame()
            
            
        }
    }
    
    private func presentGameOverScreen() {
        self.currentGameState = .gameOver
    }
    
}

#Preview {
    GameView(currentGameState: .constant(GameState.playing))
}



