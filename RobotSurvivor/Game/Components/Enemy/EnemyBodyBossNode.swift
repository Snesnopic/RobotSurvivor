//
//  EnemyBodyBossNode.swift
//  Robot Survivor
//
//  Created by Giuseppe Francione on 21/03/24.
//

import Foundation
import SpriteKit

class EnemyBodyBossNode: EnemyNode {
    var nodeToFollow: EnemyNode
    var nodeThatFollowsMe: EnemyBodyBossNode?
    var direction: Direction = .up
    var headReference: EnemyBossNode
    init(type: EnemyType, startPosition: CGPoint, nodeToFollow: EnemyNode, headReference: EnemyBossNode) {
        self.nodeToFollow = nodeToFollow
        self.headReference = headReference
        super.init(type: type, startPosition: startPosition)

        name = "enemyBoss"+type.name
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("LOL NO")
    }

    override func configureMovement(_ player: SKSpriteNode) {
        let dx = player.position.x - self.position.x
        let dy = player.position.y - self.position.y

        let angleRadians = atan2(dy, dx)
        let angleDegrees = angleRadians * (180.0 / CGFloat.pi)

        let directionBefore = direction
        switch angleDegrees {
        case 157.5 ..<  180.0:
            direction = .left
        case 112.5 ..< 157.5:
            direction = .upleft
        case 67.5 ..< 112.5:
            direction = .up
        case 22.5 ..< 67.5:
            direction = .upright
        case -22.5 ..< 22.5:
            direction = .right
        case -67.5 ..< -22.5:
            direction = .downright
        case -112.5 ..< -67.5:
            direction = .down
        case -157.5 ..< -112.5:
            direction = .downleft
        default:
            direction = .left
        }

        if directionBefore != direction {
            self.configureIdleAnimation()
        }

        let distance = abs(hypot(position.x - player.position.x, position.y - player.position.y))
        let action = SKAction.move(to: player.position, duration: distance / self.movementSpeed * (isMovementSlow ? 1.5 : 1))
        run(action)
    }

    // per animazione
    override func configureIdleAnimation() {
        let enemyAtlas = SKTextureAtlas(named: "\(type.name)/Walk/\(direction.rawValue)")
        var enemyIdleTextures: [SKTexture] = []
        enemyAtlas.textureNames.sorted().forEach { string in
            let texture = enemyAtlas.textureNamed(string)
            texture.filteringMode = .nearest
            enemyIdleTextures.append(texture)
        }

        let idleAnimation = SKAction.animate(with: enemyIdleTextures, timePerFrame: 0.3)
        run(SKAction.repeatForever(idleAnimation))
    }

    // indovina?
    override func die() {
        headReference.bodyParts.remove(self)
        if nodeThatFollowsMe != nil {
            nodeThatFollowsMe!.nodeToFollow = self.nodeToFollow
        }
        let textureAtlas = SKTextureAtlas(named: "\(type.name)/Death")
        var textures: [SKTexture] = []
        textureAtlas.textureNames.sorted().forEach { string in
            let texture = textureAtlas.textureNamed(string)
            texture.filteringMode = .nearest
            textures.append(texture)
        }

        let deathAnimation = SKAction.animate(with: textures, timePerFrame: 0.3)

        let corpse = SKSpriteNode(texture: nil, size: CGSize(width: 30, height: 30))
        corpse.position = position
        corpse.zPosition = 1
        scene?.addChild(corpse)
        let actionSequence = SKAction.sequence([
            deathAnimation,
            SKAction.wait(forDuration: 0.5),
            SKAction.removeFromParent()])
        corpse.run(actionSequence)
        removeAllActions()
        removeFromParent()
    }

}
