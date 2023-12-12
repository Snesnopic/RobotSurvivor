//
//  GameScene.swift
//  UntitledGame
//
//  Created by Giuseppe Francione on 06/12/23.
//

import SpriteKit
import Foundation

struct CollisionType {
    static let all : UInt32 = UInt32.max
    static let none : UInt32 = 0
    static let player : UInt32 = 1
    static let enemy : UInt32 = 2
    static let xp: UInt32 = 3
    
}

//class playerNode: SKScene {
//    var playerNode: SKSpriteNode!
//    
//    override func didMove(to view: SKView) {
//        
//        playerNode = SKSpriteNode(color: .red, size: CGSize(width: 50, height: 50))
//        playerNode.position = CGPoint(x: size.width / 2, y: size.height / 2)
//        playerNode.physicsBody = SKPhysicsBody(rectangleOf: playerNode.size)
//        playerNode.physicsBody?.affectedByGravity = false
//        playerNode.physicsBody?.allowsRotation = false
//        
//    }
//}


class GameScene: SKScene, SKPhysicsContactDelegate {
    var lastUpdateTime: TimeInterval = 0
    var deltaTime: TimeInterval = 0
    var sceneCamera: SKCameraNode = SKCameraNode()
    var player: SKSpriteNode = SKSpriteNode(imageNamed: "player")
    var joystick: Joystick!
    // Keeps track of when the last update happend.
    // Used to calculate how much time has passed between updates.
    var gameLogic: GameLogic = GameLogic.shared
    var lastUpdate: TimeInterval = 0
    
    var isPlayerAlive = true
    
    let enemyTypes = EnemyTypesVM().enemyTypes
    
    let positions = Array(stride(from: -320, through: 320, by: 80))
    
    override init(){
        super.init(size: CGSize(width: 500, height: 500))
        view?.showsFPS = true
        view?.showsPhysics = true
        setUpGame()
    }
    
    required init?(coder aDecoder: NSCoder){
        fatalError("coder problem")
    }
    
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
        
        enemyLogic(currentTime: currentTime)
        camera?.position = player.position
        
        
        // When the level is started or after the game has been paused, the last update time is reset to the current time.
          if lastUpdateTime.isZero {
              lastUpdateTime = currentTime
        }
        // Calculate delta time since `update` was last called.
        deltaTime = currentTime - lastUpdateTime

        // Use current time as the last update time on next game loop update.
        lastUpdateTime = currentTime
    }
}
