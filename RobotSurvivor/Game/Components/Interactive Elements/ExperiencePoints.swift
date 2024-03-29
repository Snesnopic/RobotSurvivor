//
//  ExperiencePoints.swift
//  UntitledGame
//
//  Created by Linar Zinatullin on 07/12/23.
//

import Foundation
import SpriteKit

extension GameScene{
    public func gainXP(val: Int){
        let xpToLevel = player.xpToNextLevel - player.xp
        let value = xpToLevel - val
        if(value <= 0){
            levelUp()
            gainXP(val: -value)
        }else{
            player.xp += val;
            gameLogic.currentXP = player.xp
        }
    }
    
    public func generateXp(at position: CGPoint){
        
//        let newPickUp = SKSpriteNode(imageNamed: "magnet")
//        newPickUp.texture?.filteringMode = .nearest
//        newPickUp.size = CGSize(width: 20, height: 20)
//        newPickUp.name = "pickUp"
//        newPickUp.position = getPositionNearPlayer()
//        newPickUp.zPosition = 0;
//        
//        newPickUp.physicsBody = SKPhysicsBody(circleOfRadius: 7)
//        newPickUp.physicsBody?.affectedByGravity = false
//        
//        //don't insert collisionBitMask for enemies
//        newPickUp.physicsBody?.categoryBitMask = CollisionType.pickUp
//        newPickUp.physicsBody?.collisionBitMask = CollisionType.player
//
        let newXP = SKSpriteNode(imageNamed: "expOrb2")
        newXP.texture?.filteringMode = .nearest
        newXP.size = CGSize(width: 8, height: 8)
        newXP.name = "xp"
        newXP.position = position
        newXP.zPosition = 0;

        newXP.physicsBody = SKPhysicsBody(circleOfRadius: 6)
        newXP.physicsBody?.affectedByGravity = false

        //don't insert collisionBitMask for enemies
        newXP.physicsBody?.categoryBitMask = CollisionType.xp
        newXP.physicsBody?.collisionBitMask = CollisionType.none
        newXP.physicsBody?.contactTestBitMask = CollisionType.player
        xpOnMap.insert(newXP)
        addChild(newXP)
    }
    
}
