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
            
            guard let enemyNode1 = (firstBody.node as? EnemyNode) ?? (secondBody.node as? EnemyNode) else {return}
            let enemyDmg = enemyNode1.userData!["damage"] as! Double
            player.userData!["hp"] = player.userData!["hp"] as! Double - enemyDmg
            
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
                dmgSound()
                flashRed(node: player)
            }
            
            let healthBarFill = healthBar.children.last!
            let playerHp:Double = player.userData!["hp"] as! Double
            let playerMaxHp:Double = player.userData!["maxhp"] as! Double
            
            healthBarFill.xScale = CGFloat(playerHp  / playerMaxHp)
            
            guard let enemyNode2 = (firstBody.node as? EnemyNode) ?? (secondBody.node as? EnemyNode) else {return}
            enemyNode2.slowDownMovement()
        }
        
        
        //Contact between player and xp
        //TODO: Change val with enemy.xpvalue
        if ((firstBody.categoryBitMask == CollisionType.player && secondBody.categoryBitMask == CollisionType.xp) || (firstBody.categoryBitMask == CollisionType.xp && secondBody.categoryBitMask == CollisionType.player)){
            gainXP(val: 3)
            if(firstBody.categoryBitMask == CollisionType.xp){
                xpOnMap.remove(firstBody.node!)
                firstBody.node?.removeFromParent()
            }else{
                xpOnMap.remove(secondBody.node!)
                secondBody.node?.removeFromParent()
            }
        }
        
        //Contact between player and pickUps
        //TODO: change the function magnet to a more generic one with param. type (like powerUps)
        if ((firstBody.categoryBitMask == CollisionType.player && secondBody.categoryBitMask == CollisionType.pickUp) || (firstBody.categoryBitMask == CollisionType.pickUp && secondBody.categoryBitMask == CollisionType.player)){
            magnet()
            if(firstBody.categoryBitMask == CollisionType.pickUp){
                firstBody.node?.removeFromParent()
            }else{
                secondBody.node?.removeFromParent()
            }
        }
        
        //Contact between playerWeapon and enemy
        //TODO: Change val with enemy.xpvalue
        if ((firstBody.categoryBitMask == CollisionType.playerWeapon && secondBody.categoryBitMask == CollisionType.enemy) || (firstBody.categoryBitMask == CollisionType.enemy && secondBody.categoryBitMask == CollisionType.playerWeapon)){
            
            //TODO: Implement the death logic based on enemy health
            let enemyNode = [firstBody, secondBody].first { $0.categoryBitMask == CollisionType.enemy }?.node
            let bulletNode = [firstBody, secondBody].first { $0.categoryBitMask == CollisionType.playerWeapon }?.node
            
            guard let enemy = enemyNode as? EnemyNode, let bullet = bulletNode as? SKSpriteNode else {return}
                
            // TODO: Implement the death logic based on enemy health
            enemy.userData!["health"] = enemy.userData!["health"]! as! Int - dmg
            //print(enemy.userData!["health"] as Any)
            
            if((enemy.userData!["health"] as! Int)<=0){
                
                if let deathEffect = SKEmitterNode(fileNamed: "EnemyDeath"){
                    deathEffect.position = enemy.position
                    addChild(deathEffect)
                    
                }
                
                if(chance>25){
                    generateXp(at: enemy.position)
                }
                gameLogic.increaseScore(points: enemy.userData!["points"] as! Int)
                enemy.die()
            }
            else {
                flashRed(node: enemy)
            }
            bullet.removeFromParent()
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
