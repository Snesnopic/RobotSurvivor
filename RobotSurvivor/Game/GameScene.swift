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
    var isPlayerAlive = true
    var player: SKSpriteNode = SKSpriteNode()
    var healthBar: SKScene = SKScene()
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
    var xpToMagnetise: Set<SKNode> = []
    var readyToSpawnPickUp: Bool = true
    //map
    var tilePositions: Set<CGPoint> = []
    let tileSize = CGSize(width: 128, height: 128)
    var centerTile: CGPoint = CGPoint(x: 0, y: 0)
    //music
    var backgroundMusicPlayer: AVAudioPlayer?
    var currentTrack: String? = "game1"
    
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
    
    var timeSinceLastShot: TimeInterval = 0.0
    var timeSinceLastUpdate: TimeInterval = 0.0
    var bulletSoundPool: [AVAudioPlayer] = []
    var soundPool: [AVAudioPlayer] = []
    var bulletPool: [SKSpriteNode] = []
    var done: Bool = false
    var musicPool: [AVAudioPlayer] = []
    
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
        
        setupBackgroundMusic(quantityOfMusic: 2)
        setupBulletPool(quantityOfBullets: 3)
        DispatchQueue.main.async { [self] in
            
            setupBulletSoundPool(quantityOfSounds: 10)
            setupShortSoundPool(name: "HIT", quantityOfSounds: 2)
            playTracks()
        }
        
        let initialTiles = 10
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
        
        self.scene?.isPaused = (gameLogic.showPowerUp || gameLogic.showPauseMenu || gameLogic.showTutorial ) ? true : false
        
        if lastUpdateTime.isZero {
            lastUpdateTime = currentTime
        }
        
        deltaTime = currentTime - lastUpdateTime
        lastUpdateTime = currentTime
        
        let playerPosition = player.position
        if abs(CGFloat(hypot(Float(playerPosition.x - centerTile.x), Float(playerPosition.y - centerTile.y)))) > 768 {
            updateTiles()
        }
  
        for xp in xpToMagnetise{
            let distance = abs(CGFloat(hypotf(Float(xp.position.x - playerPosition.x), Float(xp.position.y - playerPosition.y))))
            let speed = 500.0
            let action =  SKAction.move(to: playerPosition, duration: distance/speed)
            xp.run(action)
        }
        
        for enemy in enemiesOnMap{
            enemy.configureMovement(player)
        }
        
        if readyToShoot && isPlayerAlive {
            shooting()
        }
        
        if readyToLoad {
            reloading()
        }
        
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
    }
    
    func shooting() {
        guard readyToShoot else { return }
        
        readyToShoot = false
        shoot()
        
        let maxFireRate = max(fireRate, 0)
        let waitAction = SKAction.wait(forDuration: 1/maxFireRate)
        let enableShootingAction = SKAction.run {
            self.readyToShoot = true
        }

        let sequence = SKAction.sequence([waitAction, enableShootingAction])
        run(sequence)
    }
    
    func reloading() {
        readyToLoad = false
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

    }
    
    func increaseSpawnRate() {
        readyToIncreaseSpawnRate = false
        self.spawnRate += 7
        
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
        
        let waitAction = SKAction.wait(forDuration: 45)
        let enableSpawnMagnetPickUpAction = SKAction.run {
            self.readyToSpawnPickUp = true
        }
        let sequence = SKAction.sequence([waitAction, enableSpawnMagnetPickUpAction])
        run(sequence, withKey: "increaseSpawnMagnetPickUp")
    }
}
