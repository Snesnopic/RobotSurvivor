//
//  GameScene.swift
//  UntitledGame
//
//  Created by Giuseppe Francione on 06/12/23.
//

import SpriteKit
import AVFoundation
import CoreHaptics
import SwiftUI

class SceneWrapper {
    static let shared = SceneWrapper()
    var scene = GameScene()
    var cutscene = CutsceneScene()
    var joystickScene: Joystick
    private init() {
        var screenWidth: CGFloat { UIScreen.main.bounds.size.width }
        var screenHeight: CGFloat { UIScreen.main.bounds.size.height }
        scene = GameScene()
        scene.size = CGSize(width: screenWidth, height: screenHeight)
        scene.scaleMode = .fill
        joystickScene = Joystick(player: scene.player, gameSceneReference: scene)
        joystickScene.size = CGSize(width: screenWidth, height: screenHeight)
        scene.joystick = joystickScene
    }
    func createScene() {
        var screenWidth: CGFloat { UIScreen.main.bounds.size.width }
        var screenHeight: CGFloat { UIScreen.main.bounds.size.height }
        scene = GameScene()
        scene.size = CGSize(width: screenWidth, height: screenHeight)
        scene.scaleMode = .fill
        joystickScene = Joystick(player: scene.player, gameSceneReference: scene)
        joystickScene.size = CGSize(width: screenWidth, height: screenHeight)
        scene.joystick = joystickScene
    }
}

class GameScene: SKScene, SKPhysicsContactDelegate {

    // important variables
    var lastUpdateTime: TimeInterval = 0
    var deltaTime: TimeInterval = 0
    var sceneCamera: SKCameraNode = SKCameraNode()
    var readyToRelocate: Bool = true
    var joystick: Joystick?
    var gameLogic: GameLogic = GameLogic.shared
    var lastUpdate: TimeInterval = 0

    // player
    var isPlayerAlive = true
    var player: PlayerNode = PlayerNode()
    var healthBar: SKScene = SKScene()
    var playerShootingTimer: Timer?
    // enemies
    var enemiesOnMap: Set<EnemyNode> = []
    var enemyTypes = EnemyTypesVM.enemyTypes
    var spawnRate: Int = 0
    var readyToIncreaseSpawnRate: Bool = true
    var readyToIncreaseEnemyPower: Bool = true
    var multiplier: Double = 0
    // weapon
    var readyToShoot: Bool = true
    var fireRate: Double = 1
    var dmg: Int = 10
    var spd: Int = 10
    // xp and pickups
    var xpOnMap: Set<SKNode> = []
    var xpToMagnetise: Set<SKNode> = []
    var readyToSpawnPickUp: Bool = true
    // map
    var tilePositions: Set<CGPoint> = []
    let tileSize = CGSize(width: 128, height: 128)
    var centerTile: CGPoint = CGPoint(x: 0, y: 0)
    // music
    var backgroundMusicPlayer: AVAudioPlayer?
    var currentTrack: String? = "game1"

    // animations
    let flashRedAction = SKAction.sequence([
        SKAction.colorize(with: .red, colorBlendFactor: 1.0, duration: 0.2),
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

    var playerWalkTextures: [SKTexture] = []
    var playerWalkAnimation = SKAction()

    var animationTextures = [SKTexture]()
    let orbTextureNames = ["expOrb", "expOrb2"]

    // sound, pools and haptic
    // MARK: I wanted to implement the soundPool for those sounds that are not that common in the game, such as hit, so that we could have one large pool in which elements of interest get extracted, but i don't know if it's better in terms of usage resource. -Dave

    var soundPool: [AVAudioPlayer] = []
    var bulletPool: [SKSpriteNode] = []
    var musicPool: [AVAudioPlayer] = []
    var bulletSoundNodes: [SKAudioNode] = []
    var xpSoundNodes: [SKAudioNode] = []
    var hapticEngine: CHHapticEngine?

    // index and concurrent sounds
    let maxConcurrentSounds: Int = 30
    var currentBulletIndex: Int = 0
    var currentXpIndex: Int = 0

    // boss
    var isBossActive: Bool = false
    var activeBoss: EnemyBossNode?

    override init() {
        super.init(size: CGSize(width: 500, height: 500))
        view?.showsFPS = true
        view?.showsPhysics = true
        setUpAnimations()
        setUpGame()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("coder problem")
    }

    override func didMove(to view: SKView) {
        camera?.setScale( 393 / (scene?.size.width)! )
        if gameLogic.stage == .prologue {
            // haptic setup
            do {
                hapticEngine = try CHHapticEngine()
                try hapticEngine?.start()
            } catch {
                print("Ascanio: \(error.localizedDescription)")
            }

            // setup of pools
            setUpSoundPoolForExperiencePickUp()
            setUpSoundPoolForBullets()
            setupBackgroundMusic(quantityOfMusic: 2)
            setupBulletPool(quantityOfBullets: 1)
            setupShortSoundPool(name: "HIT", quantityOfSounds: 1)
            playTracks()
        }
        // map setup
        let initialTiles = 10
        let tileSize = CGSize(width: 128, height: 128)

        for x in -initialTiles...initialTiles {
            for y in -initialTiles...initialTiles {
                let position = CGPoint(x: CGFloat(x) * tileSize.width, y: CGFloat(y) * tileSize.height)
                addTile(at: position)
            }
        }
        startShooting()
    }

    public func changeStage() {
        Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { _ in
            if GameLogic.shared.stage == .prologue {
                print("cambio!")
                withAnimation {
                    GameLogic.shared.stage = .cutscene
                }
            }
        }
    }

    override func update(_ currentTime: TimeInterval) {
        if self.lastUpdate == 0 {
            self.lastUpdate = currentTime
        }

        let timeElapsedSinceLastUpdate = min(currentTime - self.lastUpdate, 0.5)
        self.gameLogic.increaseTime(by: timeElapsedSinceLastUpdate)
        self.lastUpdate = currentTime
        self.enemyLogic()
        if isBossActive {
            self.bossLogic()
        }
        camera?.position = player.position

        // enable to have a wider view
        // camera?.setScale(5)
        if joystick != nil && joystick!.isJoystickActive {
            // player is moving
            if player.action(forKey: "walkAnimation") == nil {
                player.removeAction(forKey: "idleAnimation")
                let repeater = SKAction.repeatForever(playerWalkAnimation)
                player.run(repeater, withKey: "walkAnimation")
            }
        } else {
            // player is not moving
            if player.action(forKey: "idleAnimation") == nil {
                player.removeAction(forKey: "walkAnimation")
                let repeater = SKAction.repeatForever(playerIdleAnimation)
                player.run(repeater, withKey: "idleAnimation")
            }
        }
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

        for xp in xpToMagnetise {
            let distance = abs(CGFloat(hypotf(Float(xp.position.x - playerPosition.x), Float(xp.position.y - playerPosition.y))))
            let speed = 500.0
            let action =  SKAction.move(to: playerPosition, duration: distance/speed)

            xp.run(action)
        }

        for enemy in enemiesOnMap {
            enemy.configureMovement(player)
        }

        if readyToRelocate {
            relocateEnemy()
        }

        if readyToIncreaseSpawnRate {
            increaseSpawnRate()
        }

        if readyToIncreaseEnemyPower {
            increaseEnemyPower()
        }

        if readyToSpawnPickUp {
            spawnMagnetPickUp()
        }

        backgroundMusicPlayer?.volume = gameLogic.musicSwitch ? (0.6/5)*Float(gameLogic.musicVolume) : 0
    }
}
