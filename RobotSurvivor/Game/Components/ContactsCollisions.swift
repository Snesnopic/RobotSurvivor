//
//  ContactsCollisions.swift
//  UntitledGame
//
//  Created by Linar Zinatullin on 11/12/23.
//

import Foundation
import SpriteKit
import SwiftUI

struct CollisionType {
    static let all : UInt32 = UInt32.max
    static let none : UInt32 = 0
    static let player : UInt32 = 1
    static let enemy : UInt32 = 2
    static let xp: UInt32 = 4
    static let playerWeapon: UInt32 = 8
    static let pickUp: UInt32 = 6
}

extension GameScene{
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        let firstBody: SKPhysicsBody = contact.bodyA
        let secondBody: SKPhysicsBody = contact.bodyB
        let chance = Int.random(in: 1...100)
        
        //Contact between player and enemy
        if ((firstBody.categoryBitMask == CollisionType.player && secondBody.categoryBitMask == CollisionType.enemy) || (firstBody.categoryBitMask == CollisionType.enemy && secondBody.categoryBitMask == CollisionType.player)){
            
            guard let enemyNode1 = (firstBody.node as? EnemyNode) ?? (secondBody.node as? EnemyNode) else {return}
            let enemyDmg = enemyNode1.damage
            player.hp -= Int(enemyDmg)
            if player.hp <= 0 {
                player.hp = 0
                isPlayerAlive = false
            }
            updateHpBar()
            if !isPlayerAlive && player.action(forKey: "deathAnimation") == nil{
                player.removeAllActions()
                joystick?.removeAllChildren()
                joystick?.isJoystickActive = false
                joystick?.hideJoystick()
                joystick?.isPaused = true
                player.run(deathAnimation,withKey: "deathAnimation")
                playDeathSound(audioFileName: "DEATH.mp3")
                
                let waitAction = SKAction.wait(forDuration: 2.5)
                let enableEnding = SKAction.run {
                    self.finishGame()
                    self.stopTracks()
                }
                let sequence = SKAction.sequence([waitAction, enableEnding])
                run(sequence)
//                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5){
//                    self.finishGame()
//                }
                return
            }
            else if isPlayerAlive{
                playGettingHitSound(name: "HIT.mp3")
                flashRed(node: player)
            }
            else {
                return
            }
            
            guard let enemyNode2 = (firstBody.node as? EnemyNode) ?? (secondBody.node as? EnemyNode) else {return}
            enemyNode2.slowDownMovement()
        }
        
        
        //Contact between player and xp
        //TODO: Change val with enemy.xpvalue
        if ((firstBody.categoryBitMask == CollisionType.player && secondBody.categoryBitMask == CollisionType.xp) || (firstBody.categoryBitMask == CollisionType.xp && secondBody.categoryBitMask == CollisionType.player)){
            gainXP(val: 3)
            if(firstBody.categoryBitMask == CollisionType.xp){
                xpToMagnetise.remove(firstBody.node!)
                xpOnMap.remove(firstBody.node!)
                firstBody.node?.removeFromParent()
            }else{
                xpToMagnetise.remove(secondBody.node!)
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
            enemy.health -= dmg

            if enemy.health <= 0 {
                let explosion: SKNode = SKSpriteNode(texture: nil, size: CGSize(width: 30, height: 30))
                explosion.position = enemy.position
                explosion.zPosition = 2
                scene!.addChild(explosion)
                let actionSequence = SKAction.sequence([
                    explosionAnimation,
                    SKAction.removeFromParent()])
                explosion.run(actionSequence)
                
                if(chance>25){
                    generateXp(at: enemy.position)
                }
                gameLogic.increaseScore(points: enemy.points)
                enemiesOnMap.remove(enemy)
                if let boss = enemy as? EnemyBossNode {
                    activeBoss = nil
                }
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
        if node.action(forKey: "flashRed") == nil {
            node.run(flashRedAction,withKey: "flashRed")
        }
    }
}
