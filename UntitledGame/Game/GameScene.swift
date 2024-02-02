//
//  GameScene.swift
//  UntitledGame
//
//  Created by Giuseppe Francione on 06/12/23.
//

import SpriteKit
import AVFoundation

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
        scene.joystick = joystickScene
    }
}


class GameScene: SKScene, SKPhysicsContactDelegate {
    var lastUpdateTime: TimeInterval = 0
    var deltaTime: TimeInterval = 0
    var sceneCamera: SKCameraNode = SKCameraNode()
    var readyToLoad: Bool = true
    var joystick: Joystick?

    var gameLogic: GameLogic = GameLogic.shared
    var lastUpdate: TimeInterval = 0
    //player
    var playerSkin:String = "AntiTank"
    var isPlayerAlive = true
    var player: SKSpriteNode!
    var healthBar: SKScene!

    //enemies
    var enemiesOnMap: Set<EnemyNode> = []
    var enemyTypes = EnemyTypesVM().enemyTypes
    var spawnRate: Int = 0
    var readyToIncreaseSpawnRate: Bool = true
    var readyToIncreaseEnemyPower: Bool = true
    var multiplier: Double = 0
    //weapon
    var readyToShoot: Bool = true
    var shootDirection: CGVector = CGVector(dx: 1, dy: 0)
    var fireRate: Double = 1
    var dmg: Int = 10
    var spd: Int = 10
    //xp and pickups
    var xpOnMap: Set<SKNode> = []
    var xpToMagnetise: Set<SKNode> = []
    var readyToSpawnPickUp: Bool = true
    //map
    var tilePositions: Set<CGPoint> = []
    let tileSize = CGSize(width: 100, height: 100)
    //music
    var backgroundMusicPlayer: AVAudioPlayer?
    var currentTrack: String?
    
    var isBossReady = true
    
    var timer: Timer?
    //animations
    let flashRedAction = SKAction.sequence([
        SKAction.colorize(with: .red , colorBlendFactor: 1.0, duration: 0.2),
        SKAction.wait(forDuration: 0.1),
        SKAction.colorize(withColorBlendFactor: 0.0, duration: 0.15)])
    
    let explosionAtlas = SKTextureAtlas(named: "Explosions/Small")
    var explosionTextures: [SKTexture] = []
    var explosionAnimation: SKAction = SKAction()
    
    var deathAnimationTextures: [SKTexture] = []
    var deathAnimation: SKAction = SKAction()
    
    var playerIdleTextures: [SKTexture] = []
    var playerIdleAnimation = SKAction()

    var shootAnimationTextures: [SKTexture] = []
    var shootAnimation = SKAction()
    
    override init(){
        super.init(size: CGSize(width: 500, height: 500))
        view?.showsFPS = true
        view?.showsPhysics = true
        setUpAnimations()
        setUpGame()
    }
    
    required init?(coder aDecoder: NSCoder){
        fatalError("coder problem")
    }
    
    
    override func didMove(to view: SKView) {
        print("You are in the game scene!")
        //Music
        playTracks()
        
        let initialTiles = 20
        let tileSize = CGSize(width: 128, height: 128)
        
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
        
        if(self.lastUpdate == 0){
            self.lastUpdate = currentTime
        }
        
        let timeElapsedSinceLastUpdate = min(currentTime - self.lastUpdate, 0.5)
        
        self.gameLogic.increaseTime(by: timeElapsedSinceLastUpdate)
        
        self.lastUpdate = currentTime
        
        self.enemyLogic()
        
        camera?.position = player.position
        
        //enable to have a wider view
        //camera?.setScale(5)
        
        if ((gameLogic.showPowerUp) || gameLogic.showPauseMenu){
            self.scene?.isPaused = true
        }else{
            self.scene?.isPaused = false
        }
        
        if lastUpdateTime.isZero {
            lastUpdateTime = currentTime
        }
        
        deltaTime = currentTime - lastUpdateTime
        
        
        lastUpdateTime = currentTime
        
        if readyToShoot && isPlayerAlive{
            readyToShoot = false
            shoot()
            DispatchQueue.main.asyncAfter(deadline: .now() + TimeInterval(fireRate)) {
                self.readyToShoot = true
            }
        }
        
        let playerPosition = player.position
        for xp in xpToMagnetise{
                let distance = abs(CGFloat(hypotf(Float(xp.position.x - playerPosition.x), Float(xp.position.y - playerPosition.y))))
                let speed = 500.0
                let action =  SKAction.move(to: playerPosition, duration: distance/speed)
                xp.run(action)
        }
        
            for enemy in enemiesOnMap{
                enemy.configureMovement(player)
            }
        
        if readyToLoad {
            readyToLoad = false
            updateTiles()
            for enemy in enemiesOnMap{
                if distanceBetween(node1: enemy, node2: player) > Float((frame.height + frame.width)/2.8){
                    relocateEnemy(enemy: enemy)
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.readyToLoad = true
            }
        }
        
        if readyToIncreaseSpawnRate {
            readyToIncreaseSpawnRate = false
            self.spawnRate = self.spawnRate + 7
            DispatchQueue.main.asyncAfter(deadline: .now() + 35) {
                self.readyToIncreaseSpawnRate = true
            }
        }
        
        if readyToIncreaseEnemyPower {
            readyToIncreaseEnemyPower = false
            multiplier = multiplier + 1
            //print(multiplier)
            DispatchQueue.main.asyncAfter(deadline: .now() + 55) {
                self.readyToIncreaseEnemyPower = true
            }
        }
        
        if readyToSpawnPickUp{
            readyToSpawnPickUp = false
            spawnPickUp()
            DispatchQueue.main.asyncAfter(deadline: .now() + 60) {
                self.readyToSpawnPickUp = true
            }
        }
        
        if gameLogic.musicSwitch {
            backgroundMusicPlayer?.volume = (0.6/5)*Float(self.gameLogic.musicVolume)
        } else {
            backgroundMusicPlayer?.volume = 0
        }
        
        
    }
    
}

