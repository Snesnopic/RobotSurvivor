//
//  EnemyBossNode.swift
//  Robot Survivor
//
//  Created by Giuseppe Francione on 21/03/24.
//

import Foundation
import SpriteKit

enum Direction: String {
    case downleft = "Down-Left"
    case downright = "Down-Right"
    case down = "Down"
    case left = "Left"
    case right = "Right"
    case upleft = "Up-Left"
    case upright = "Up-Right"
    case up = "Up"

}

class EnemyBossNode: EnemyNode {
    var direction: Direction = .up
    var bodyParts: Set<EnemyBodyBossNode> = []
    var isDead: Bool = false
    weak var gameScene: GameScene?
    init(type: EnemyType, startPosition: CGPoint, parts: Int, gameScene: GameScene) {
        super.init(type: type, startPosition: startPosition)
        self.type = type
        self.points = type.points
        self.health = type.health
        self.damage = type.damage
        self.movementSpeed = type.speed
        self.gameScene = gameScene

        let bossPartEnemyType = EnemyTypesVM.enemyTypes.first(where: { enemy in
            return enemy.name == "CentipedeBody"
        })!

        name = "enemy" + type.name
        configureIdleAnimation()
        position = startPosition
        let firstBodyPart = EnemyBodyBossNode(type: bossPartEnemyType, startPosition: startPosition, nodeToFollow: self, headReference: self)
        bodyParts.insert(firstBodyPart)
        var previousNode: EnemyBodyBossNode = firstBodyPart

        for _ in 1..<parts {
            let bodyPart = EnemyBodyBossNode(type: bossPartEnemyType, startPosition: startPosition, nodeToFollow: previousNode, headReference: self)
            previousNode.nodeThatFollowsMe = bodyPart
            previousNode = bodyPart
            bodyParts.insert(bodyPart)
        }

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
        bodyParts.forEach { bodyPart in
            bodyPart.die()
        }
        if type.name == "CentipedeHead" {

            self.gameScene?.isBossActive = false
            print(type.name)
            isDead = true
        }
        removeAllActions()
        removeFromParent()

        if isDead {
            Timer.scheduledTimer(withTimeInterval: 5, repeats: false, block: { _ in
                self.gameScene!.changeStage()
            })
        }
    }

    // movimento
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

    required init?(coder aDecoder: NSCoder) {
        fatalError("LOL NO")
    }
}
