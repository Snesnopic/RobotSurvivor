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
        
        //this is done this way for 2 things: first, the animation would hurt the eyes of the user. Second, after testing, enemies would be hard to see if the "glowing" of the orbs would remain for too long on the screen
        let animateAction = SKAction.animate(with: animationTextures, timePerFrame: 0.06)
        let staticDuration = 0.94
        let waitAction = SKAction.wait(forDuration: staticDuration)
        let sequenceAction = SKAction.sequence([waitAction, animateAction])
        let repeatAction = SKAction.repeatForever(sequenceAction)
        
        newXP.run(repeatAction)
        addChild(newXP)
        
    }
}
