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
    var health: Int
    
    init(type: EnemyType,  startPosition: CGPoint) {
        
        self.type = type
        self.health = type.health
        let texture = SKTexture(imageNamed: "\(type.name)/Walk/1")
        super.init(texture: texture,color: .white, size: texture.size())
        
        name = "enemy" + type.name
        
        physicsBody = SKPhysicsBody(polygonFrom: CGPath(ellipseIn: CGRectMake(self.position.x-10, self.position.y-10, texture.size().width, texture.size().height), transform: nil))
        
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
            self.xScale = 1
        }
        else {
            self.xScale = -1
        }
        let speed = type.speed
        let distance = abs(CGFloat(hypotf(Float(self.position.x - player.position.x), Float(self.position.y - player.position.y))))
        
        let action = SKAction.move(to: player.position, duration: distance/speed)
        run(action)
        //        let path = UIBezierPath()
        //        path.move(to: .zero)
        //
        //        path.addLine(to: CGPoint(x: player.position.x - self.position.x, y: player.position.y - self.position.y))
        //
        //        let movement = SKAction.follow(path.cgPath,asOffset: true, orientToPath: true, speed: type.speed)
        //        let sequence = SKAction.sequence([movement])
        //
        //        run(sequence)
    }
}

