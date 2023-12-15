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
        self.userData = ["health": type.health, "speed": type.speed, "points":type.points]
        
        name = "enemy" + type.name
        
        var enemyAtlas: SKTextureAtlas {
            return SKTextureAtlas(named: "\(type.name)/Walk")
        }
        var enemyIdleTextures: [SKTexture] = []
        enemyAtlas.textureNames.forEach { string in
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
        var textureAtlas: SKTextureAtlas = SKTextureAtlas(named: "\(type.name)/Death")
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
            SKAction.wait(forDuration: 1.0),
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
        let speed = type.speed
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

