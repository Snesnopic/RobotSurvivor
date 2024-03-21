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
    @StateObject var gameLogic: GameLogic =  GameLogic.shared
    @State var sceneWrapper = SceneWrapper()
    
    var body: some View {
        ZStack {
            SpriteView(scene: self.sceneWrapper.scene)
                .onChange(of: gameLogic.showPowerUp, perform: { value in
                    if(gameLogic.showPowerUp == false){
                        sceneWrapper.scene.isPaused = false
                    }
                })
                .onChange(of: gameLogic.showPauseMenu,perform: {
                    value in
                    if(gameLogic.showPauseMenu == false){
                        sceneWrapper.scene.isPaused = false
                    }
                })
            
                .onChange(of: gameLogic.showTutorial,perform: {
                    value in
                    if(gameLogic.showTutorial == false){
                        sceneWrapper.scene.isPaused = false
                    }
                })
                .ignoresSafeArea()
            
            SpriteView(scene: sceneWrapper.joystickScene,options: [.allowsTransparency])
                .onChange(of: gameLogic.showPowerUp,perform: {
                    value in
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
                })
                .onChange(of: gameLogic.showPauseMenu, perform: {
                    value in
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
                })
                .ignoresSafeArea()
            
                .onChange(of: gameLogic.showTutorial, perform: {
                    value in
                    if(gameLogic.showTutorial == true){
                        sceneWrapper.joystickScene.isPaused = true
                    }else{
                        sceneWrapper.joystickScene.isPaused = false
                    }
                    
                    if(gameLogic.showTutorial == false){
                        sceneWrapper.joystickScene.showJoystick()
                    }else{
                        sceneWrapper.joystickScene.hideJoystick()
                    }
                })
            
            ExpView(experienceNeeded: $gameLogic.xpToNextLvl ,currentXP: $gameLogic.currentXP, currentLevel: $gameLogic.playerLevel)
            
            ScoreView(score: $gameLogic.currentScore, time: $gameLogic.time)
                .padding(.vertical)
            
            if(gameLogic.showPowerUp){
                PowerUpView(sceneWrap: $sceneWrapper)
            }
            if(gameLogic.showPauseMenu){
                PauseMenuView(gameLogic: gameLogic ,currentGameState: $currentGameState, sceneWrap: $sceneWrapper);
            }
            
            if(gameLogic.showTutorial){
                TutorialView(gameLogic: gameLogic ,currentGameState: $currentGameState, sceneWrap: $sceneWrapper)
            }
            
            
            
        }.onChange(of: gameLogic.isGameOver,perform: {
            value in
            if gameLogic.isGameOver {
                self.presentGameOverScreen()
            }
        })
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



