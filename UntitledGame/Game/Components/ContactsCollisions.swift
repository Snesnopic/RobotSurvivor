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
            
            
            if (player.userData!["hp"] as! Int) <= 0 {
                let soundEffect = SKAction.playSoundFileNamed("DEATH.mp3", waitForCompletion: false)
                self.scene?.run(soundEffect)
                gameLogic.isGameOver = true
                self.scene?.isPaused = true
                stopTracks()
                player.userData!["hp"] = 0
                return
            }
            else {
                let soundEffect = SKAction.playSoundFileNamed("HIT.mp3", waitForCompletion: false)
                self.scene?.run(soundEffect)
                flashRed(node: player)
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
            let enemy = [firstBody,secondBody].filter { node in
                node.categoryBitMask == CollisionType.enemy
            }.first!.node as! EnemyNode
            let bullet = [firstBody,secondBody].filter { node in
                node.categoryBitMask == CollisionType.playerWeapon
            }.first!.node
            
            enemy.userData!["health"] = enemy.userData!["health"]! as! Int - dmg
            //print(enemy.userData!["health"] as Any)
            if((enemy.userData!["health"] as! Int)<=0){
                if(chance>50){
                    generateXp(at: enemy.position)
                }
                gameLogic.increaseScore(points: enemy.userData!["points"] as! Int)
                enemy.removeFromParent()
            }
            else {
                flashRed(node: enemy)
            }
            bullet?.removeFromParent()
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
    func flashRed(node: SKNode) {
        let action =  SKAction.sequence([
            SKAction.colorize(with: .red , colorBlendFactor: 1.0, duration: 0.2),
            SKAction.wait(forDuration: 0.1),
            SKAction.colorize(withColorBlendFactor: 0.0, duration: 0.15)])
        node.run(action)
    }
}
