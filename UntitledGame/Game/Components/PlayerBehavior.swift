//
//  ShotLogic.swift
//  UntitledGame
//
//  Created by Linar Zinatullin on 13/12/23.
//

import Foundation
import SpriteKit

extension GameScene{
    
    func shoot(damage: Int, speed: Int){
        guard !isGameOver else {return}
        let dmg = damage
        let spd = speed
        let shot = SKSpriteNode(imageNamed: "playerWeapon")
        shot.name = "playerWeapon"
        shot.position = player.position
        
        shot.userData = ["damage": dmg, "speed": spd]
        shot.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: shot.size.width/2, height: shot.size.height/2))
        shot.physicsBody?.categoryBitMask = CollisionType.playerWeapon
        shot.physicsBody?.collisionBitMask =  CollisionType.enemy
        shot.physicsBody?.contactTestBitMask = CollisionType.enemy
        shot.physicsBody?.isDynamic = false
        shot.zPosition = 2
        addChild(shot)
        
        
        let movement = SKAction.move(to: CGPoint(x: player.position.x + (2000 * shootDirection.dx ) , y: player.position.y + (shootDirection.dy * 2000)),duration: shot.userData!["speed"] as! TimeInterval)
        let sequence = SKAction.sequence([movement, .removeFromParent()])
        shot.run(sequence)
        
    }
}
