//
//  EnemyNode.swift
//  UntitledGame
//
//  Created by Linar Zinatullin on 11/12/23.
//

import Foundation
import SpriteKit

class EnemyNode: SKSpriteNode {
    var type: EnemyType
    var isMovementSlow: Bool = true
    
    init(type: EnemyType,  startPosition: CGPoint) {
        
        self.type = type
        let texture = SKTexture(imageNamed: "\(type.name)/Walk/1")
        
        super.init(texture: texture,color: .white, size: CGSize(width: 20, height: 20))
        self.userData = ["health": type.health, "speed": type.speed, "points":type.points, "damage": type.damage]
        
        name = "enemy" + type.name
        
        var enemyAtlas: SKTextureAtlas {
            return SKTextureAtlas(named: "\(type.name)/Walk")
        }
        var enemyIdleTextures: [SKTexture] = []
        enemyAtlas.textureNames.sorted().forEach { string in
            let texture = enemyAtlas.textureNamed(string)
            texture.filteringMode = .nearest
            enemyIdleTextures.append(texture)
        }
        
        let idleAnimation = SKAction.animate(with: enemyIdleTextures, timePerFrame: 0.3)
        self.run(SKAction.repeatForever(idleAnimation),withKey: "playerIdleAnimation")
        
        physicsBody = SKPhysicsBody(polygonFrom: CGPath(ellipseIn: CGRectMake(self.position.x-10, self.position.y-10, 20, 20), transform: nil))
        
        //        (polygonFrom: CGPath(ellipseIn: CGRectMake(self.position.x, self.position.y, texture.size().width, texture.size().height), transform: nil))
        
        //        attackCircle = SKShapeNode(ellipseOfSize: CGSize(width: 1000, height: 400))
        //        attackCircle.physicsBody = SKPhysicsBody(polygonFromPath: CGPathCreateWithEllipseInRect(CGRectMake(-500, -200, 1000, 400), nil))
        
        physicsBody?.categoryBitMask = CollisionType.enemy
        physicsBody?.collisionBitMask = CollisionType.player | CollisionType.enemy
        physicsBody?.contactTestBitMask = CollisionType.player
        physicsBody?.isDynamic = true
        physicsBody?.allowsRotation = false
        position = startPosition
        
    }
    
    func die() {
        let textureAtlas: SKTextureAtlas = SKTextureAtlas(named: "\(type.name)/Death")
        var textures: [SKTexture] = []
        textureAtlas.textureNames.forEach { string in
            let texture = textureAtlas.textureNamed(string)
            texture.filteringMode = .nearest
            textures.append(texture)
        }

        let idleAnimation = SKAction.animate(with: textures, timePerFrame: 0.3)
        
        let corpse: SKNode = SKSpriteNode(texture: nil, size: CGSize(width: 30, height: 30))
        corpse.position = self.position
        corpse.zPosition = 1
        self.scene!.addChild(corpse)
        let actionSequence = SKAction.sequence([
            idleAnimation,
            SKAction.wait(forDuration: 0.5),
            SKAction.removeFromParent()])
        corpse.run(actionSequence)
        self.removeFromParent()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("LOL NO")
    }
    
    
    func configureMovement(_ player: SKSpriteNode){
        if self.position.x < player.position.x {
            if self.xScale < 0 {
                self.xScale *= -1
            }
        }
        else {
            if self.xScale >= 0 {
                self.xScale *= -1
            }
        }
        let distance = abs(CGFloat(hypotf(Float(self.position.x - player.position.x), Float(self.position.y - player.position.y))))
        let speed = self.userData?.value(forKey: "speed") as! CGFloat
        let action =  SKAction.move(to: player.position, duration: distance/speed * (isMovementSlow ? 1.5 : 1))
        run(action)
        
    }
    
    func slowDownMovement() {
        removeAllActions()
        isMovementSlow = true
        
    }
    func speedUpMovement(){
        removeAllActions()
        isMovementSlow = false
        
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
    
//    func addParts() {
//        var nodeToFollow: SKSpriteNode = self
//        for _ in 0..<4{
//            let enemyNode = EnemyBodyBossNode(type: type.parts, startPosition: CGPoint(x: .zero + 10, y: .zero + 10), nodeToFollow: nodeToFollow)
//            nodeToFollow = enemyNode.self
//            self.addChild(enemyNode)
//            
//        }
//    }
    
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
