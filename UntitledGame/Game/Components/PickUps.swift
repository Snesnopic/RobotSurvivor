//
//  PickUps.swift
//  UntitledGame
//
//  Created by Giuseppe Casillo on 16/12/23.
//

import Foundation
import SpriteKit

extension GameScene{
    func spawnPickUp(){
        //TODO: Add different pickup such as FOOD, MAGNET, TEMPORARY INVINCIBILITY ETC.ETC. and also different sprites
        let newPickUp = SKSpriteNode(imageNamed: "magnet")
        newPickUp.texture?.filteringMode = .nearest
        newPickUp.size = CGSize(width: 20, height: 20)
        newPickUp.name = "pickUp"
        newPickUp.position = getPositionNearPlayer()
        newPickUp.zPosition = 0;
        
        newPickUp.physicsBody = SKPhysicsBody(circleOfRadius: 7)
        newPickUp.physicsBody?.affectedByGravity = false
        
        //don't insert collisionBitMask for enemies
        newPickUp.physicsBody?.categoryBitMask = CollisionType.pickUp
        newPickUp.physicsBody?.collisionBitMask = CollisionType.player
        
        addChild(newPickUp)
    }
    
    func magnet(){
        let playerPosition = player.position

        for xp in xpOnMap{
                let distance = abs(CGFloat(hypotf(Float(xp.position.x - playerPosition.x), Float(xp.position.y - playerPosition.y))))
                let speed = 500.0
                let action =  SKAction.move(to: playerPosition, duration: distance/speed)
                xp.run(action)
        }
    }
}
