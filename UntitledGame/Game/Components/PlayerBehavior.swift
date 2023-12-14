//
//  ShotLogic.swift
//  UntitledGame
//
//  Created by Linar Zinatullin on 13/12/23.
//

import Foundation
import SpriteKit

extension GameScene{
    
    func shoot(speed: Int){
        guard !isGameOver else {return}
        let shot = SKSpriteNode(imageNamed: "playerWeapon")
        shot.texture?.filteringMode = .nearest
        shot.name = "playerWeapon"
        shot.position = player.position
        
        shot.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: shot.size.width/2, height: shot.size.height/2))
        shot.physicsBody?.categoryBitMask = CollisionType.playerWeapon
        shot.physicsBody?.collisionBitMask =  CollisionType.enemy
        shot.physicsBody?.contactTestBitMask = CollisionType.enemy
        shot.physicsBody?.isDynamic = false
        shot.zPosition = 2
        addChild(shot)
        
        
        let movement = SKAction.move(to: CGPoint(x: player.position.x + (2000 * shootDirection.dx ) , y: player.position.y + (shootDirection.dy * 2000)),duration: TimeInterval(speed))
        let sequence = SKAction.sequence([movement, .removeFromParent()])
        shot.run(sequence)
        
    }
}
