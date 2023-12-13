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
        shot.userData = ["damage": 1, "speed": 4]
        shot.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: shot.size.width/2, height: shot.size.height/2))
        shot.physicsBody?.categoryBitMask = CollisionType.playerWeapon
        shot.physicsBody?.collisionBitMask =  CollisionType.enemy
        shot.physicsBody?.contactTestBitMask = CollisionType.enemy
        shot.physicsBody?.isDynamic = false
        shot.zPosition = 2
        addChild(shot)
        
        let movement = SKAction.move(to: CGPoint(x: 1000, y: shot.position.y),duration: shot.userData!["speed"] as! TimeInterval)
        let sequence = SKAction.sequence([movement, .removeFromParent()])
        shot.run(sequence)
        
    }
}
