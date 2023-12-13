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
        if ((firstBody.categoryBitMask == CollisionType.player && secondBody.categoryBitMask == CollisionType.enemy) || (firstBody.categoryBitMask == CollisionType.enemy && secondBody.categoryBitMask == CollisionType.player)){
            player.userData!["hp"] = player.userData!["hp"] as! Double - 10

            if (player.userData!["hp"] as! Int) < 0 {
                player.userData!["hp"] = 0
            }
            
            let healthBarFill = healthBar.children.last!
            let playerHp:Double = player.userData!["hp"] as! Double
            let playerMaxHp:Double = player.userData!["maxhp"] as! Double
                        
            healthBarFill.xScale = CGFloat(playerHp  / playerMaxHp)
            
            player.userData!["hp"] = player.userData!["hp"] as! Int - 10
            guard let enemyNode = (firstBody.node as? EnemyNode) ?? (secondBody.node as? EnemyNode) else {return}
            enemyNode.slowDownMovement()
        }
       
        
        //Contact between player and xp
        //TODO: Change val with enemy.xpvalue
        if ((firstBody.categoryBitMask == CollisionType.player && secondBody.categoryBitMask == CollisionType.xp) || (firstBody.categoryBitMask == CollisionType.xp && secondBody.categoryBitMask == CollisionType.player)){
            gainXP(val: 3)
            if(firstBody.categoryBitMask == CollisionType.xp){
                firstBody.node?.removeFromParent()
            }else{
                secondBody.node?.removeFromParent()
            }
        }
        
        //Contact between playerWeapon and enemy
        //TODO: Change val with enemy.xpvalue
        if ((firstBody.categoryBitMask == CollisionType.playerWeapon && secondBody.categoryBitMask == CollisionType.enemy) || (firstBody.categoryBitMask == CollisionType.enemy && secondBody.categoryBitMask == CollisionType.playerWeapon)){
            
            //TODO: Implement the death logic based on enemy health
            
            if(firstBody.categoryBitMask == CollisionType.enemy){
                let enemy = firstBody.node as! EnemyNode
                enemy.userData!["health"] = enemy.userData!["health"]! as! Int - 10
                print(enemy.userData!["health"] as Any)
                if((enemy.userData!["health"] as! Int)<=0){
                    if(chance>50){
                        generateXp(at: firstBody.node!.position)
                    }
                    firstBody.node?.removeFromParent()
                }
                secondBody.node?.removeFromParent()
            }else{
                let enemy = secondBody.node as! EnemyNode
                enemy.userData!["health"] = enemy.userData!["health"]! as! Int - 10
                print(enemy.userData!["health"] as Any)
                if((enemy.userData!["health"] as! Int)<=0){
                    if(chance>50){
                        generateXp(at: secondBody.node!.position)
                    }
                    secondBody.node?.removeFromParent()
                }
                firstBody.node?.removeFromParent()
            }
            
        }
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        let firstBody: SKPhysicsBody = contact.bodyA
        let secondBody: SKPhysicsBody = contact.bodyB
        //Contact between player and enemy
        if ((firstBody.categoryBitMask == CollisionType.player && secondBody.categoryBitMask == CollisionType.enemy) || (firstBody.categoryBitMask == CollisionType.enemy && secondBody.categoryBitMask == CollisionType.player)){
            guard let enemyNode = (firstBody.node as? EnemyNode) ?? (secondBody.node as? EnemyNode) else {return}
            enemyNode.speedUpMovement()
        }
       
    }
    
}
