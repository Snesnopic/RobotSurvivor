//
//  ShotLogic.swift
//  UntitledGame
//
//  Created by Linar Zinatullin on 13/12/23.
//

import Foundation
import SpriteKit

extension GameScene{
    
    func shoot(){
        guard !isGameOver else {return}
        
        let shot = SKSpriteNode(imageNamed: "playerWeapon")
        shot.name = "playerWeapon"
        shot.position = player.position
        
        shot.physicsBody = SKPhysicsBody(rectangleOf: shot.size)
        shot.physicsBody?.categoryBitMask = CollisionType.playerWeapon
        shot.physicsBody?.collisionBitMask =  CollisionType.enemy
        shot.physicsBody?.contactTestBitMask = CollisionType.enemy
        shot.physicsBody?.isDynamic = true
        addChild(shot)
        
        let movement = SKAction.move(to: CGPoint(x: 1000, y: shot.position.y),duration: 5)
        let sequence = SKAction.sequence([movement, .removeFromParent()])
        shot.run(sequence)
        
    }
}
