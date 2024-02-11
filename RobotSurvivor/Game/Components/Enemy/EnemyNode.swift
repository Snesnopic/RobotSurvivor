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

    init(type: EnemyType, startPosition: CGPoint) {
        self.type = type
        let texture = SKTexture(imageNamed: "\(type.name)/Walk/1")

        super.init(texture: texture, color: .white, size: CGSize(width: 20, height: 20))
        configureAppearance()
        configurePhysics()
        configureIdleAnimation()
        position = startPosition

    }
    
    //per configurazione apparenza
    func configureAppearance() {
        userData = ["health": type.health, "speed": type.speed, "points": type.points, "damage": type.damage]
        name = "enemy" + type.name
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

        let idleAnimation = SKAction.animate(with: textures, timePerFrame: 0.3)

        let corpse = SKSpriteNode(texture: nil, size: CGSize(width: 30, height: 30))
        corpse.position = position
        corpse.zPosition = 1
        scene?.addChild(corpse)
        let actionSequence = SKAction.sequence([
            idleAnimation,
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
        let speed = userData?.value(forKey: "speed") as! CGFloat
        let action = SKAction.move(to: player.position, duration: distance / speed * (isMovementSlow ? 1.5 : 1))
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

class EnemyBossNode: SKSpriteNode {
    var type: EnemyBossType
    
    init(type: EnemyBossType, startPosition: CGPoint) {
        self.type = type
        let texture = SKTexture(imageNamed: "enemy3")
        
        
        super.init(texture: texture, color: .white, size: CGSize(width: 20, height: 20))
        self.userData = ["health": type.health, "speed": type.speed,
                         "points": type.points]
        
        name = "enemyBoss"+type.name
        
        
        physicsBody = SKPhysicsBody(polygonFrom: CGPath(ellipseIn: CGRectMake(self.position.x-10, self.position.y-10, 20, 20), transform: nil))
        
        physicsBody?.categoryBitMask = CollisionType.enemy
        physicsBody?.collisionBitMask = CollisionType.player | CollisionType.enemy
        physicsBody?.contactTestBitMask = CollisionType.none
        physicsBody?.isDynamic = true
        physicsBody?.allowsRotation = true
        position = startPosition
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("LOL NO")
    }
    
    func configureMovement(_ player: SKSpriteNode){
       
        let distance = abs(CGFloat(hypotf(Float(self.position.x - player.position.x), Float(self.position.y - player.position.y))))
        let speed = type.speed
        let action =  SKAction.move(to: player.position, duration: distance/speed )
        run(action)
        
    }
    
}

class EnemyBodyBossNode: SKSpriteNode {
    var type: EnemyType
    var nodeToFollow: SKSpriteNode
    init(type: EnemyType, startPosition: CGPoint, nodeToFollow: SKSpriteNode) {
        self.type = type
        let texture = SKTexture(imageNamed: "enemy1")
        self.nodeToFollow = nodeToFollow
        
        super.init(texture: texture, color: .white, size: CGSize(width: 20, height: 20))
        self.userData = ["health": type.health, "speed": type.speed,
                         "points": type.points]
        
        name = "enemyBoss"+type.name
        
        
        physicsBody = SKPhysicsBody(polygonFrom: CGPath(ellipseIn: CGRectMake(self.position.x-10, self.position.y-10, 20, 20), transform: nil))
        
        physicsBody?.categoryBitMask = CollisionType.enemy
        physicsBody?.collisionBitMask = CollisionType.player | CollisionType.enemy
        physicsBody?.contactTestBitMask = CollisionType.none
        physicsBody?.isDynamic = true
        physicsBody?.allowsRotation = true
        position = startPosition
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("LOL NO")
    }
    
    func configureMovement(){
        let distance = abs(CGFloat(hypotf(Float(self.position.x - nodeToFollow.position.x), Float(self.position.y - nodeToFollow.position.y))))
        let speed = type.speed
        let offset: Double = distance < 10 ? 2 : 1
        let  action =  SKAction.move(to: nodeToFollow.position, duration: 0.3)
        run(action)
        
    }
}
