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
        let action = SKAction.move(by: CGVector(dx: 300, dy: -200), duration: 1.5)
        let sceneCamera = SKCameraNode()
        camera = sceneCamera
        self.addChild(camera!)
        camera!.run(action)

        let playerIdleAtlas: SKTextureAtlas = SKTextureAtlas(named: "AntiTank/Idle")
        var playerIdleTextures: [SKTexture] = []
        playerIdleAtlas.textureNames.sorted().forEach { string in
            let texture = playerIdleAtlas.textureNamed(string)
            texture.filteringMode = .nearest
            playerIdleTextures.append(texture)
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

        let waitAction = SKAction.wait(forDuration: 2.0)
        let moveAction = SKAction.move(by: CGVector(dx: 2000, dy: 0), duration: 5)

        player.run(SKAction.sequence([waitAction, playerWalkAnimation, moveAction]))
    }

    override func update(_ currentTime: TimeInterval) {

    }

}

#Preview {
    CutsceneView(currentGameState: .constant(GameState.playing))
}
