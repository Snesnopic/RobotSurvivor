//
//  GameScene.swift
//  UntitledGame
//
//  Created by Giuseppe Francione on 06/12/23.
//

import SpriteKit
import AVFoundation

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

extension CGPoint: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(x)
        hasher.combine(y)
    }
}


class GameScene: SKScene, SKPhysicsContactDelegate, ObservableObject {
    static let shared: GameScene = GameScene()
    var lastUpdateTime: TimeInterval = 0
    var deltaTime: TimeInterval = 0
    var sceneCamera: SKCameraNode = SKCameraNode()
    var player: SKSpriteNode!
    var healthBar: SKScene!
    var joystick: Joystick!
  
    var gameLogic: GameLogic = GameLogic.shared
    var lastUpdate: TimeInterval = 0
    var isPlayerAlive = true
    
    let enemyTypes = EnemyTypesVM().enemyTypes
    
    var readyToShoot: Bool = true
    var shootDirection: CGVector = CGVector(dx: 1, dy: 0)
    
    var fireRate: Double = 2
    var dmg: Int = 10
    var spd: Int = 10
    
    var tilePositions: Set<CGPoint> = []
    let tileSize = CGSize(width: 100, height: 100)
    
    var backgroundMusicPlayer: AVAudioPlayer?
    
    var currentTrack: String?
    
    override init(){
        super.init(size: CGSize(width: 500, height: 500))
        view?.showsFPS = true
        view?.showsPhysics = true
        setUpGame()
    }
    
    required init?(coder aDecoder: NSCoder){
        fatalError("coder problem")
    }
    
    
    func updateTiles() {
        let playerPosition = player.position
        let visibleDistance = 500
        
       
        let minX = playerPosition.x - CGFloat(visibleDistance)
        let maxX = playerPosition.x + CGFloat(visibleDistance)
        let minY = playerPosition.y - CGFloat(visibleDistance)
        let maxY = playerPosition.y + CGFloat(visibleDistance)
        
        // Load new tiles
        for x in stride(from: minX, through: maxX, by: tileSize.width) {
            for y in stride(from: minY, through: maxY, by: tileSize.height) {
                let position = CGPoint(x: x, y: y)
                if !isTilePresent(at: position) {
                    addTile(at: position)
                }
            }
        }
        for tile in self.children.compactMap({ $0 as? SKSpriteNode }) {
            if tile.position.x < minX || tile.position.x > maxX ||
                tile.position.y < minY || tile.position.y > maxY {
                tilePositions.remove(tile.position)
                tile.removeFromParent()
            }
        }
  
    }
    
    func isTilePresent(at position: CGPoint) -> Bool {
        return tilePositions.contains(position)
    }
    
    func addTile(at position: CGPoint) {
        let tileImageName: String
        let tileType = Int.random(in: 1...100)
        if(tileType <= 70){
           tileImageName = "Tile3"
        }else if(tileType>70 && tileType <= 85){
            tileImageName = "Tile1"
        }else{
            tileImageName = "Tile2"
        }
         
        let tile = SKSpriteNode(imageNamed: tileImageName)
        tile.position = position
        addChild(tile)

        tilePositions.insert(position)
    }
    
    override func didMove(to view: SKView) {
        print("You are in the game scene!")
        
        //Music
        playTracks()
        
        let initialTiles = 30
        let tileSize = CGSize(width: 100, height: 100)
        
        for x in -initialTiles...initialTiles {
            for y in -initialTiles...initialTiles {
                let position = CGPoint(x: CGFloat(x) * tileSize.width, y: CGFloat(y) * tileSize.height)
                addTile(at: position)
            }
        }
        
    }
    
    func distanceBetween(node1: SKNode, node2: SKNode) -> Float {
        return hypotf(Float(node1.position.x - node2.position.x), Float(node1.position.y - node2.position.y))
    }
    override func update(_ currentTime: TimeInterval) {
        if(self.isGameOver){
            gameLogic.finishGame()
        }
        if(self.lastUpdate == 0){
            self.lastUpdate = currentTime
        }
        
        let timeElapsedSinceLastUpdate = currentTime - self.lastUpdate
      
        self.gameLogic.increaseTime(by: timeElapsedSinceLastUpdate)
        
        self.lastUpdate = currentTime
        
        enemyLogic(currentTime: currentTime)
        camera?.position = player.position
        
        
      
        if lastUpdateTime.isZero {
            lastUpdateTime = currentTime
        }
       
        deltaTime = currentTime - lastUpdateTime
        
       
        lastUpdateTime = currentTime
        
        if readyToShoot {
            readyToShoot = false
            shoot(speed: spd)
            DispatchQueue.main.asyncAfter(deadline: .now() + TimeInterval(fireRate)) {
                self.readyToShoot = true
            }
        }
        updateTiles()
    }
    
  }

