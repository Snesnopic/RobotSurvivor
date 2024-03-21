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
    var direction:Direction = .up
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
//        let scaleFactor: CGFloat = (position.x < player.position.x) ? 1 : -1
//        if xScale != scaleFactor {
//            xScale *= -1
//        }

        let distance = abs(hypot(position.x - player.position.x, position.y - player.position.y))
        let action = SKAction.move(to: player.position, duration: distance / self.movementSpeed * (isMovementSlow ? 1.5 : 1))
        run(action)
    }
    
    //per animazione
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
    
    //indovina?
    override func die() {
        headReference.bodyParts.remove(self)
        let textureAtlas = SKTextureAtlas(named: "\(type.name)/Death")
        var textures: [SKTexture] = []
        textureAtlas.textureNames.forEach { string in
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
        removeFromParent()
    }
    
}
