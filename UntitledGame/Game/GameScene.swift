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
    var fireRate: Double = 1
    var dmg: Int = 10
    var spd: Int = 10
    //xp and pickups
    var xpOnMap: Set<SKNode> = []
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
        
        //        if readyToShoot && isPlayerAlive{
        //            readyToShoot = false
        //            shoot()
        //            DispatchQueue.main.asyncAfter(deadline: .now() + TimeInterval(fireRate)) {
        //                self.readyToShoot = true
        //            }
        //        }
        
//        if readyToShoot && isPlayerAlive {
//            readyToShoot = false
//            shoot()
//            
//            let maxFireRate = max(fireRate, 0)
//            let waitAction = SKAction.wait(forDuration: maxFireRate)
//            let enableShootingAction = SKAction.run {
//                self.readyToShoot = true
//            }
//            print(maxFireRate)
//            let sequence = SKAction.sequence([waitAction, enableShootingAction])
//            run(sequence, withKey: "shootingSequence")
//        }
        for enemy in enemiesOnMap{
            enemy.configureMovement(player)
        }
        
        if readyToShoot && isPlayerAlive {
            shooting()
        }
        
        if readyToLoad {
            reloading()
        }
        
        //        if readyToIncreaseSpawnRate {
        //            readyToIncreaseSpawnRate = false
        //            self.spawnRate = self.spawnRate + 14
        //            DispatchQueue.main.asyncAfter(deadline: .now() + 35) {
        //                self.readyToIncreaseSpawnRate = true
        //            }
        //        }
        if readyToIncreaseSpawnRate {
            increaseSpawnRate()
        }
        
        if readyToIncreaseEnemyPower {
            increaseEnemyPower()
        }
        
        if readyToSpawnPickUp{
            spawnMagnetPickUp()
        }
        
        backgroundMusicPlayer?.volume = gameLogic.musicSwitch ? (0.6/5)*Float(gameLogic.musicVolume) : 0

//        if gameLogic.musicSwitch {
//            backgroundMusicPlayer?.volume = (0.6/5)*Float(self.gameLogic.musicVolume)
//        } else {
//            backgroundMusicPlayer?.volume = 0
//        }
    }
    
    func shooting() {
        let maxFireRate = max(fireRate, 0)
        readyToShoot = false
        shoot()
        
        let waitAction = SKAction.wait(forDuration: 1/maxFireRate)
        let enableShootingAction = SKAction.run {
            self.readyToShoot = true
        }
        
        let sequence = SKAction.sequence([waitAction, enableShootingAction])
        run(sequence)
    }
    func reloading() {
        readyToLoad = false
        updateTiles()
        for enemy in enemiesOnMap{
            if distanceBetween(node1: enemy, node2: player) > Float((frame.height + frame.width)/2.8){
                relocateEnemy(enemy: enemy)
            }
        }
        let waitAction = SKAction.wait(forDuration: 3)
        let enableReload = SKAction.run {
            self.readyToLoad = true
        }
        
        let sequence = SKAction.sequence([waitAction, enableReload])
        run(sequence)
//            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
//                self.readyToLoad = true
//            }
    }
    
    func increaseSpawnRate() {
        readyToIncreaseSpawnRate = false
        self.spawnRate += 10
        
        let waitAction = SKAction.wait(forDuration: 35)
        let enableSpawnRateIncreaseAction = SKAction.run {
            self.readyToIncreaseSpawnRate = true
        }
        
        let sequence = SKAction.sequence([waitAction, enableSpawnRateIncreaseAction])
        run(sequence, withKey: "increaseSpawnRateAction")
    }
    
    func increaseEnemyPower() {
        readyToIncreaseEnemyPower = false
        multiplier = multiplier + 1

        let waitAction = SKAction.wait(forDuration: 55)
        let enableIncreaseEnemyPowerAction = SKAction.run {
            self.readyToIncreaseEnemyPower = true
        }
        let sequence = SKAction.sequence([waitAction, enableIncreaseEnemyPowerAction])
        run(sequence, withKey: "increaseEnemyRatePower")
    }
    
    func spawnMagnetPickUp() {
        readyToSpawnPickUp = false
        spawnPickUp()
        
        let waitAction = SKAction.wait(forDuration: 60)
        let enableSpawnMagnetPickUpAction = SKAction.run {
            self.readyToSpawnPickUp = true
        }
        let sequence = SKAction.sequence([waitAction, enableSpawnMagnetPickUpAction])
        run(sequence, withKey: "increaseSpawnMagnetPickUp")
    }
}

//func startSpawnRateIncreaseTimer() {
//    spawnRateIncreaseTimer = Timer.scheduledTimer(
//        timeInterval: 60.0,
//        target: self,
//        selector: #selector(increaseSpawnRate),
//        userInfo: nil,
//        repeats: false
//    )
//}
//
//@objc func increaseSpawnRate() {
//    readyToIncreaseSpawnRate = false
//    self.spawnRate += 7
//    self.readyToIncreaseSpawnRate = true
//}
//
//func startIncreaseEnemyPowerTimer() {
//    enemyPowerTimer = Timer.scheduledTimer(
//        timeInterval: 55.0,
//        target: self,
//        selector: #selector(increaseEnemyPower),
//        userInfo: nil,
//        repeats: true
//    )
//}
//
//@objc func increaseEnemyPower() {
//    readyToIncreaseEnemyPower = false
//    multiplier = multiplier + 1
//    self.readyToIncreaseEnemyPower = true
//}
//
//func startSpawnMagnetPickUpTimer() {
//    magnetTimer = Timer.scheduledTimer(
//        timeInterval: 35.0,
//        target: self,
//        selector: #selector(spawnMagnetPickUp),
//        userInfo: nil,
//        repeats: true
//    )
//}
//
//@objc func spawnMagnetPickUp() {
//    readyToSpawnPickUp = false
//    spawnPickUp()
//    self.readyToSpawnPickUp = true
//}
