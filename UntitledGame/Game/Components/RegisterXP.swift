//
//  RegisterXP.swift
//  UntitledGame
//
//  Created by Linar Zinatullin on 07/12/23.
//

import Foundation
import SpriteKit

extension GameScene{
    public func gainXP(val: Int){
        player.userData!["xp"] = player.userData!["xp"] as! Int + val;
        gameLogic.currentXP = player.userData!["xp"] as! Int
    }
    
    public func generateXp(at position: CGPoint){
        let newXP = SKShapeNode(circleOfRadius: 2)
        newXP.name = "xp"
        newXP.fillColor = SKColor.green
        newXP.position = position
        newXP.zPosition = 0;

        newXP.physicsBody = SKPhysicsBody(circleOfRadius: 2)
        newXP.physicsBody?.affectedByGravity = false
        
        //don't insert collisionBitMask for enemies
        newXP.physicsBody?.categoryBitMask = CollisionType.xp
        newXP.physicsBody?.collisionBitMask = CollisionType.player
        
        addChild(newXP)
    }
    
}
