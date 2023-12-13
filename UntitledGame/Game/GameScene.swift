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
    static let playerWeapon: UInt32 = 4
    
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

class SceneWrapper{
    var scene = GameScene()
    var joystickScene: Joystick
    init() {
        var screenWidth: CGFloat { UIScreen.main.bounds.size.width }
        var screenHeight: CGFloat { UIScreen.main.bounds.size.height }
        
        scene = GameScene()
        scene.size = CGSize(width: screenWidth, height: screenHeight)
        scene.scaleMode = .fill
        joystickScene = Joystick(player: scene.player,gameSceneReference: scene)
        joystickScene.size = CGSize(width: screenWidth, height: screenHeight)
    }
}

class GameScene: SKScene, SKPhysicsContactDelegate, ObservableObject {
    var lastUpdateTime: TimeInterval = 0
    var deltaTime: TimeInterval = 0
    var sceneCamera: SKCameraNode = SKCameraNode()
    var player: SKSpriteNode = SKSpriteNode(imageNamed: "player")
    var healthBar: SKScene!
    var joystick: Joystick!
    // Keeps track of when the last update happend.
    // Used to calculate how much time has passed between updates.
    var gameLogic: GameLogic = GameLogic.shared
    var lastUpdate: TimeInterval = 0
    
    var isPlayerAlive = true
    
    let enemyTypes = EnemyTypesVM().enemyTypes
    
    var readyToShoot: Bool = true
    
    override init(){
        super.init(size: CGSize(width: 500, height: 500))
        view?.showsFPS = true
        view?.showsPhysics = true
        setUpGame()
    }
    
    required init?(coder aDecoder: NSCoder){
        fatalError("coder problem")
    }
    
    func addTile(at position: CGPoint) {
        let tileType = Int.random(in: 1...2) // Randomly choose between 1 and 2
        let tileImageName = tileType == 1 ? "terrainAsset" : "terrainAsset2" // Choose the image based on random selection
        let tile = SKSpriteNode(imageNamed: tileImageName)
        tile.position = position
        addChild(tile)
    }
    
    override func didMove(to view: SKView) {
        print("You are in the game scene!")
        
        let initialTiles = 5  // Number of tiles in each direction from the center
        let tileSize = CGSize(width: 100, height: 100)  // Replace with your tile size

        for x in -initialTiles...initialTiles {
            for y in -initialTiles...initialTiles {
                let position = CGPoint(x: CGFloat(x) * tileSize.width, y: CGFloat(y) * tileSize.height)
                addTile(at: position)
            }
        }
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        if(self.isGameOver){
            gameLogic.finishGame()
            updateTiles()
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
        
        if readyToShoot {
            readyToShoot = false
            shoot()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.readyToShoot = true
            }
        }
        
    }
    func updateTiles() {
        let playerPosition = player.position
            let visibleDistance = 200  // Adjust as needed

            // Calculate the bounds of the visible area
        _ = playerPosition.x - CGFloat(visibleDistance)
        _ = playerPosition.x + CGFloat(visibleDistance)
        _ = playerPosition.y - CGFloat(visibleDistance)
        _ = playerPosition.y + CGFloat(visibleDistance)

    }
}
