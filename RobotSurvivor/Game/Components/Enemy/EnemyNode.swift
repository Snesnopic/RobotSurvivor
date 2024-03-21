//
//  EnemyNode.swift
//  UntitledGame
//
//  Created by Linar Zinatullin on 11/12/23.
//

import Foundation
import SpriteKit

//ho riordinato un po' il codice
class EnemyNode: SKSpriteNode {
    
    var type: EnemyType
    var isMovementSlow: Bool = true
    var points:Int
    var health:Int
    var damage:Double
    var movementSpeed:Double
    init(type: EnemyType, startPosition: CGPoint) {
        self.type = type
        self.points = type.points
        self.health = type.health
        self.damage = type.damage
        self.movementSpeed = type.speed
        let texture = SKTexture(imageNamed: "\(type.name)/Walk/1")
        
        super.init(texture: texture, color: .white, size: CGSize(width: 20, height: 20))

        name = "enemy" + type.name
        configurePhysics()
        configureIdleAnimation()
        position = startPosition

    }
    
  
    
    //per parametri di fisica e collisioni
    func configurePhysics() {
        physicsBody = SKPhysicsBody(polygonFrom: CGPath(ellipseIn: CGRect(x: position.x - 10, y: position.y - 10, width: 20, height: 20), transform: nil))
        physicsBody?.categoryBitMask = CollisionType.enemy
        physicsBody?.collisionBitMask = CollisionType.player | CollisionType.enemy
        physicsBody?.contactTestBitMask = CollisionType.player
        physicsBody?.isDynamic = true
        physicsBody?.allowsRotation = false
    }
    
    //per animazione
    func configureIdleAnimation() {
        let enemyAtlas = SKTextureAtlas(named: "\(type.name)/Walk")
        var enemyIdleTextures: [SKTexture] = []
        enemyAtlas.textureNames.sorted().forEach { string in
            let texture = enemyAtlas.textureNamed(string)
            texture.filteringMode = .nearest
            enemyIdleTextures.append(texture)
        }

        let idleAnimation = SKAction.animate(with: enemyIdleTextures, timePerFrame: 0.3)
        run(SKAction.repeatForever(idleAnimation), withKey: "playerIdleAnimation")
    }
    
    //indovina?
    func die() {
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
    
    //movimento
    func configureMovement(_ player: SKSpriteNode) {
        let scaleFactor: CGFloat = (position.x < player.position.x) ? 1 : -1
        if xScale != scaleFactor {
            xScale *= -1
        }

        let distance = abs(hypot(position.x - player.position.x, position.y - player.position.y))
        let action = SKAction.move(to: player.position, duration: distance / self.movementSpeed * (isMovementSlow ? 1.5 : 1))
        run(action)
    }
    
    //movimenti
    func slowDownMovement() {
        removeAllActions()
        isMovementSlow = true
    }

    func speedUpMovement() {
        removeAllActions()
        isMovementSlow = false
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("LOL NO")
    }
}

enum Direction: String{
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
    init(type: EnemyType, startPosition: CGPoint, parts: Int) {
        super.init(type: type, startPosition: startPosition)
        self.type = type
        self.points = type.points
        self.health = type.health
        self.damage = type.damage
        self.movementSpeed = type.speed
                
        let bossPartEnemyType = EnemyTypesVM.enemyTypes.first(where: { enemy in
            return enemy.name == "CentipedeBody"
        })!
        
        
        name = "enemy" + type.name
        configureIdleAnimation()
        position = startPosition
        var previousNode: EnemyNode = self
        for i in 0..<parts {
            let bodyPart = EnemyBodyBossNode(type: bossPartEnemyType, startPosition: CGPoint(x: previousNode.position.x, y: previousNode.position.y - 5), nodeToFollow: previousNode, headReference: self)
            previousNode = bodyPart
            bodyParts.insert(bodyPart)
        }
        
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
        bodyParts.forEach { bodyPart in
            bodyPart.die()
        }
        removeFromParent()
    }
    
    //movimento
    override func configureMovement(_ player: SKSpriteNode) {
        let scaleFactor: CGFloat = (position.x < player.position.x) ? 1 : -1
        if xScale != scaleFactor {
            xScale *= -1
        }

        let distance = abs(hypot(position.x - player.position.x, position.y - player.position.y))
        let action = SKAction.move(to: player.position, duration: distance / self.movementSpeed * (isMovementSlow ? 1.5 : 1))
        run(action)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("LOL NO")
    }
}


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
