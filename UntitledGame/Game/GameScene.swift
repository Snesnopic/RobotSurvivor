//
//  GameScene.swift
//  UntitledGame
//
//  Created by Giuseppe Francione on 06/12/23.
//

import SpriteKit
import Foundation



class playerNode: SKScene {
    var playerNode: SKSpriteNode!
    
    override func didMove(to view: SKView) {
        
        playerNode = SKSpriteNode(color: .red, size: CGSize(width: 50, height: 50))
        playerNode.position = CGPoint(x: size.width / 2, y: size.height / 2)
        addChild(playerNode)
        
        playerNode.physicsBody = SKPhysicsBody(rectangleOf: playerNode.size)
        playerNode.physicsBody?.affectedByGravity = false
        playerNode.physicsBody?.allowsRotation = false
    }
}


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
