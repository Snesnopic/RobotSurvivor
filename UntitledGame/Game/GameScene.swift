//
//  GameScene.swift
//  UntitledGame
//
//  Created by Giuseppe Francione on 06/12/23.
//

import SpriteKit

class GameScene: SKScene {
    
    var player: SKSpriteNode!
    // Keeps track of when the last update happend.
    // Used to calculate how much time has passed between updates.
    var gameLogic: GameLogic = GameLogic.shared
    var lastUpdate: TimeInterval = 0
    
    override func didMove(to view: SKView) {
        print("You are in the game scene!")
    }
    
    override func update(_ currentTime: TimeInterval) {
        if(self.isGameOver){
            gameLogic.finishGame()
        }
        if(self.lastUpdate == 0){
            self.lastUpdate = currentTime
        }
        // Calculates how much time has passed since the last update
        let timeElapsedSinceLastUpdate = currentTime - self.lastUpdate
        // Increments the length of the game session at the game logic
        self.gameLogic.increaseTime(by: timeElapsedSinceLastUpdate)
        
        self.lastUpdate = currentTime
        
    }
}
