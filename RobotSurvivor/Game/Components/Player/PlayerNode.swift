//
//  PlayerNode.swift
//  Robot Survivor
//
//  Created by Giuseppe Francione on 12/03/24.
//

import Foundation
import SpriteKit

class PlayerNode: SKSpriteNode {
    var level:Int
    var xp:Int
    var xpToNextLevel:Int
    var movementSpeed:Int
    var hp:Int
    var maxHp:Int
    init() {
        level = 1
        xp = 0
        xpToNextLevel = 10
        movementSpeed = 70
        hp = 100
        maxHp = 100
        
        super.init(texture: nil, color: .white, size: CGSize(width: 30, height: 30))
        
        name = "player"
        position = position
        physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 20, height:  20))
        
        zPosition = 3
        position = CGPoint(x: 0, y: 0)
        physicsBody?.categoryBitMask = CollisionType.player
        physicsBody?.collisionBitMask = CollisionType.enemy
        physicsBody?.contactTestBitMask = CollisionType.enemy
        physicsBody?.isDynamic = false
        physicsBody?.affectedByGravity = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
