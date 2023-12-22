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
            let enemyDmg = enemyNode1.userData!["damage"] as! Double
            player.userData!["hp"] = player.userData!["hp"] as! Double - enemyDmg
            guard let playerHp:Double = player.userData!["hp"] as? Double else {return}
            if playerHp <= 0 {
                player.userData!["hp"] = 0
                isPlayerAlive = false
            }
            if !isPlayerAlive && player.action(forKey: "deathAnimation") == nil{
                player.removeAllActions()
                let spriteAtlas = SKTextureAtlas(named: "AntiTank/Death")
                var textures: [SKTexture] = []
                spriteAtlas.textureNames.forEach { string in
                    let texture = spriteAtlas.textureNamed(string)
                    texture.filteringMode = .nearest
                    textures.append(texture)
                }
                let deathAnimation = SKAction.animate(with: textures, timePerFrame: 0.5)
                joystick?.removeAllChildren()
                joystick?.isJoystickActive = false
                joystick?.hideJoystick()
                joystick?.isPaused = true
                player.run(deathAnimation,withKey: "deathAnimation")
                playSound(audioFileName: "DEATH.mp3")
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5){
                    self.finishGame()
                }
                return
            }
            else if isPlayerAlive{
                playSound(audioFileName: "HIT.mp3")
                flashRed(node: player)
            }
            else {
                return
            }
            
            let healthBarFill = healthBar.children.last!
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

            if((enemy.userData!["health"] as! Int)<=0){
                
                let explosionAtlas = SKTextureAtlas(named: "Explosions/Small")
                var explosionTextures: [SKTexture] = []
                explosionAtlas.textureNames.sorted().forEach { string in
                    let texture = explosionAtlas.textureNamed(string)
                    texture.filteringMode = .nearest
                    explosionTextures.append(texture)
                }
                let explosionAnimation = SKAction.animate(with: explosionTextures, timePerFrame: 0.07)
                
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
                gameLogic.increaseScore(points: enemy.userData!["points"] as! Int)
                enemiesOnMap.remove(enemy)
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
        if node.action(forKey: "flashRed") == nil {
            node.run(action,withKey: "flashRed")
        }
    }
}
