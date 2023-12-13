//
//  ContactsCollisions.swift
//  UntitledGame
//
//  Created by Linar Zinatullin on 11/12/23.
//

import Foundation
import SpriteKit
import SwiftUI

extension GameScene{
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        let firstBody: SKPhysicsBody = contact.bodyA
        let secondBody: SKPhysicsBody = contact.bodyB
        let chance = Int.random(in: 1...100)
        
        //Contact between player and enemy
        if firstBody.categoryBitMask == CollisionType.player && secondBody.categoryBitMask == CollisionType.enemy{
            player.userData!["hp"] = player.userData!["hp"] as! Int - 10
            if(chance>50){
                generateXp(at: secondBody.node!.position)
            }
            secondBody.node?.removeFromParent()
            
        }
        if firstBody.categoryBitMask == CollisionType.enemy && secondBody.categoryBitMask == CollisionType.player{
            player.userData!["hp"] = player.userData!["hp"] as! Int - 10
            if(chance>50){
                generateXp(at: firstBody.node!.position)
            }
            firstBody.node?.removeFromParent()
            
        }
        
        //Contact between player and xp
        //TODO: Change val with enemy.xpvalue
        if firstBody.categoryBitMask == CollisionType.player && secondBody.categoryBitMask == CollisionType.xp{
            gainXP(val: 3)
            secondBody.node?.removeFromParent()
            print(player.userData!["xp"]!)
            
        }
        if firstBody.categoryBitMask == CollisionType.xp && secondBody.categoryBitMask == CollisionType.player{
            gainXP(val: 3)
            
            firstBody.node?.removeFromParent()
            print(player.userData!["xp"]!)
            
        }
        
        //TODO: use when the player gets hurt
        let healthBarFill = healthBar.children.last!
        let playerHp:Int = player.userData!["hp"] as! Int
        let playerMaxHp:Int = player.userData!["maxhp"] as! Int
        
        print("Player HP: \(playerHp)")
        print("Player MaxHP: \(playerMaxHp)")
        print("Calculation: \(playerHp * Int(player.size.width) / playerMaxHp)")
        healthBarFill.xScale = CGFloat(playerHp * Int(player.size.width) / playerMaxHp)
    }
    
    func stopEnemyMovement(_ enemy: EnemyNode) {
        enemy.removeAllActions()  // This stops the follow path action
        enemy.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        print("stop Move")
    }
}
