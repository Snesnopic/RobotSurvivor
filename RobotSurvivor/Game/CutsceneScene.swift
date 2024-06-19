//
//  CutsceneScene.swift
//  Robot Survivor
//
//  Created by Giuseppe Francione on 18/06/24.
//

import Foundation
import SpriteKit
import SwiftUI
import CoreHaptics

class CutsceneScene: SKScene, SKPhysicsContactDelegate {

    var hapticEngine: CHHapticEngine?

    override init() {
        let width = UIScreen.main.bounds.width
        let height = UIScreen.main.bounds.height
        super.init(size: CGSize(width: width, height: height))
        view?.showsFPS = true
        view?.showsPhysics = true
        do {
            hapticEngine = try CHHapticEngine()
            try hapticEngine?.start()
        } catch {
            print("Ascanio: \(error.localizedDescription)")
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("coder problem")
    }

    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = .zero

        CutsceneSetup()
        CameraSetup()

        let playerIdleTextures = createPlayerTextures()

        playExplosionSoundAndHaptic()
        playExplosionVFX()

        playerCutsceneSetup(textures: playerIdleTextures)

    }

    override func update(_ currentTime: TimeInterval) {}

    func instantiateHapticPattern() {
        if let explosionHaptic = createHitHapticPattern() {
            do {
                let explosion = try hapticEngine?.makePlayer(with: explosionHaptic)
                try explosion?.start(atTime: 0)
                print("i entered")
            } catch {
                print("Ascanio: explosion")
            }
        }
    }

    func createHitHapticPattern() -> CHHapticPattern? {
        do {
            let hapticEvent = CHHapticEvent(
                eventType: .hapticContinuous,
                parameters: [
                    // tweak these for intensity and sharpness
                    CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.7),
                    CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.2)
                ],
                // tweak these for duration
                relativeTime: 0,
                duration: 0.1
            )
            return try CHHapticPattern(events: [hapticEvent], parameters: [])
        } catch {
            print("Failed to create haptic pattern: \(error.localizedDescription)")
            return nil
        }
    }

    func CutsceneSetup() {
        let factoryTexture = SKTexture(imageNamed: "factory")
        factoryTexture.filteringMode = .nearest
        let factoryNode = SKSpriteNode(texture: factoryTexture)
        self.addChild(factoryNode)
    }

    func CameraSetup() {

        let action = SKAction.move(by: CGVector(dx: 300, dy: -200), duration: 3.0)
        let sceneCamera = SKCameraNode()
        camera = sceneCamera
        self.addChild(camera!)
        camera!.run(action)
        camera?.setScale(393 / (scene?.size.width)!)
    }

    func createPlayerTextures() -> [SKTexture] {
        let playerIdleAtlas = SKTextureAtlas(named: "AntiTank/Idle")
        var playerIdleTextures: [SKTexture] = []
        playerIdleAtlas.textureNames.sorted().forEach { string in
            let texture = playerIdleAtlas.textureNamed(string)
            texture.filteringMode = .nearest
            playerIdleTextures.append(texture)
        }
        return playerIdleTextures
    }

    func playExplosionSoundAndHaptic() {
        if let soundURL = Bundle.main.url(forResource: "explosion", withExtension: "wav") {
            for _ in 0..<34 {
                let audioNode = SKAudioNode(url: soundURL)
                audioNode.autoplayLooped = false
                audioNode.name = "EXPLOSION"
                addChild(audioNode)

                let runVibration = SKAction.run {
                    self.instantiateHapticPattern()
                }
                let waitAction = SKAction.wait(forDuration: Double.random(in: 0...7))
                let volume = SKAction.changeVolume(to: GameLogic.shared.soundsSwitch ? (0.1/5) * Float(GameLogic.shared.soundsVolume) : 0, duration: 0)

                audioNode.run(SKAction.sequence([waitAction, runVibration, volume, SKAction.play()]))
            }
        }
    }

    func playExplosionVFX() {
        var explosionTextures: [SKTexture] = []
        for _ in 0..<320 {
            let expType = Int.random(in: 0...1)
            let explosionAtlas = SKTextureAtlas(named: "Explosions/\(expType == 1 ? "Big" : "Small")")

            explosionAtlas.textureNames.sorted().forEach { string in
                let texture = explosionAtlas.textureNamed(string)
                texture.filteringMode = .nearest
                explosionTextures.append(texture)
            }

            explosionSequence(explosionTextures: explosionTextures)
        }
    }

    func playerCutsceneSetup(textures: [SKTexture]) {
        let playerWalkAtlas: SKTextureAtlas = SKTextureAtlas(named: "AntiTank/Walk")
        var playerWalkTextures: [SKTexture] = []
        playerWalkAtlas.textureNames.sorted().forEach { string in
            let texture = playerWalkAtlas.textureNamed(string)
            texture.filteringMode = .nearest
            playerWalkTextures.append(texture)
        }
        let playerWalkAnimation = SKAction.animate(with: playerWalkTextures, timePerFrame: 0.1)

        let player = SKSpriteNode(texture: textures.first!)
        player.size.width *= 2
        player.size.height *= 2
        player.position = CGPoint(x: 300, y: -350)
        player.zPosition = 10
        self.addChild(player)

        let waitAction = SKAction.wait(forDuration: 3.5)
        let moveAction = SKAction.move(by: CGVector(dx: 2000, dy: 0), duration: 4)
        let changeStageAction = SKAction.run {
            GameLogic.shared.stage = .main
        }

        player.run(SKAction.sequence([waitAction, playerWalkAnimation, moveAction, changeStageAction]))
    }

    func explosionSequence(explosionTextures: [SKTexture]) {
        let explosionAnimation = SKAction.animate(with: explosionTextures, timePerFrame: 0.07)
        let explosion: SKNode = SKSpriteNode(texture: nil, size: explosionTextures.first!.size())
        explosion.xScale = 5
        explosion.yScale = 5
        explosion.position.y += CGFloat(Double.random(in: -150...200))
        explosion.position.x += CGFloat(Double.random(in: -20...300))
        explosion.zPosition = 2
        scene!.addChild(explosion)
        let actionSequence = SKAction.sequence([
            SKAction.wait(forDuration: Double.random(in: (0.0)...(7.0))),
            explosionAnimation,
            SKAction.removeFromParent()])
        explosion.run(actionSequence)
    }

}

#Preview {
    CutsceneView(currentGameState: .constant(GameState.playing))
}
