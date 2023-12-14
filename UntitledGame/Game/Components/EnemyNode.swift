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
        self.userData = ["health": type.health, "speed": type.speed]
        
        name = "enemy" + type.name
        
        var enemyAtlas: SKTextureAtlas {
            return SKTextureAtlas(named: "\(type.name)/Walk")
        }
        var enemyIdleTextures: [SKTexture] {
            var textures: [SKTexture] = []
            textures.append( enemyAtlas.textureNamed("1"))
            textures.append( enemyAtlas.textureNamed("2"))
            textures.append( enemyAtlas.textureNamed("3"))
            textures.append( enemyAtlas.textureNamed("4"))
            textures.forEach { texture in
                texture.filteringMode = .nearest
            }
            return textures
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
    func flashRed() {
       let action =  SKAction.sequence([
        SKAction.colorize(with: .red , colorBlendFactor: 1.0, duration: 0.5),
            SKAction.wait(forDuration: 0.1),
            SKAction.colorize(withColorBlendFactor: 0.0, duration: 0.15)])
        self.run(action)
    }
}

