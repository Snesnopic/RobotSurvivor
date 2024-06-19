//
//  CutsceneScene.swift
//  Robot Survivor
//
//  Created by Giuseppe Francione on 18/06/24.
//

import Foundation
import SpriteKit
import SwiftUI

class CutsceneScene: SKScene, SKPhysicsContactDelegate {
    override init() {
        let width = UIScreen.main.bounds.width
        let height = UIScreen.main.bounds.height
        super.init(size: CGSize(width: width, height: height))
        view?.showsFPS = true
        view?.showsPhysics = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("coder problem")
    }

    override func didMove(to view: SKView) {
        let factoryTexture = SKTexture(imageNamed: "factory")
        factoryTexture.filteringMode = .nearest
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = .zero
        let factoryNode = SKSpriteNode(texture: factoryTexture)
        self.addChild(factoryNode)
        let action = SKAction.move(by: CGVector(dx: 300, dy: -200), duration: 3.0)
        let sceneCamera = SKCameraNode()
        camera = sceneCamera
        self.addChild(camera!)
        camera!.run(action)
        print(scene?.size)
        camera?.setScale( 393 / (scene?.size.width)! )
        let playerIdleAtlas: SKTextureAtlas = SKTextureAtlas(named: "AntiTank/Idle")
        var playerIdleTextures: [SKTexture] = []
        playerIdleAtlas.textureNames.sorted().forEach { string in
            let texture = playerIdleAtlas.textureNamed(string)
            texture.filteringMode = .nearest
            playerIdleTextures.append(texture)
        }
        for i in 0..<320 {
            let expType = Int.random(in: 0...1)
            let explosionAtlas = SKTextureAtlas(named: "Explosions/\(expType == 1 ? "Big" : "Small")")
            var explosionTextures: [SKTexture] = []
            explosionAtlas.textureNames.sorted().forEach { string in
                let texture = explosionAtlas.textureNamed(string)
                texture.filteringMode = .nearest
                explosionTextures.append(texture)
            }
            var explosionAnimation = SKAction.animate(with: explosionTextures, timePerFrame: 0.07)
            let explosion: SKNode = SKSpriteNode(texture: nil, size: explosionTextures.first!.size())
            explosion.xScale = 5
            explosion.yScale = 5
            explosion.position.y += CGFloat(Double.random(in: -150...200))
            explosion.position.x += CGFloat(Double.random(in: -20...300))
            explosion.zPosition = 2
            scene!.addChild(explosion)
            let actionSequence = SKAction.sequence([
                SKAction.wait(forDuration: Double.random(in: (0.0)...(10.0))),
                explosionAnimation,
                SKAction.removeFromParent()])
            explosion.run(actionSequence)
        }

        let playerWalkAtlas: SKTextureAtlas = SKTextureAtlas(named: "AntiTank/Walk")
        var playerWalkTextures: [SKTexture] = []
        playerWalkAtlas.textureNames.sorted().forEach { string in
            let texture = playerWalkAtlas.textureNamed(string)
            texture.filteringMode = .nearest
            playerWalkTextures.append(texture)
        }
        let playerWalkAnimation = SKAction.animate(with: playerWalkTextures, timePerFrame: 0.1)

        let player = SKSpriteNode(texture: playerIdleTextures.first!)
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

    override func update(_ currentTime: TimeInterval) {

    }

}

#Preview {
    CutsceneView(currentGameState: .constant(GameState.playing))
}
