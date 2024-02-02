//
//  ShotLogic.swift
//  UntitledGame
//
//  Created by Linar Zinatullin on 13/12/23.
//

import Foundation
import SpriteKit

extension GameScene{
    
    func levelUp(){
        player.userData!["level"] = (player.userData!["level"] as? Int)! + 1
        player.userData!["xp"] = 0
        let nextLevelXp = (player.userData!["xpToNextLevel"] as? Int)! + 10
        player.userData!["xpToNextLevel"] = nextLevelXp
        gameLogic.xpToNextLvl = nextLevelXp
        
        gameLogic.showPowerUp = true
    }
    
    func shoot(){
        guard !isGameOver else {return}
        let shot = SKSpriteNode(imageNamed: "bullet")
        shot.texture?.filteringMode = .nearest
        shot.name = "bullet"
        shot.position = player.position
        player.run(shootAnimation)
        shot.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: shot.size.width/3, height: shot.size.height/3))
        shot.physicsBody?.categoryBitMask = CollisionType.playerWeapon
        shot.physicsBody?.collisionBitMask =  CollisionType.enemy
        shot.physicsBody?.contactTestBitMask = CollisionType.enemy
        shot.physicsBody?.isDynamic = false
        shot.zPosition = 2
        shot.setScale(1.5)
        addChild(shot)
        
        let activeEnemies = children.compactMap{$0 as? EnemyNode}
       guard let closestEnemy: EnemyNode = activeEnemies.sorted(by: { first, second in
            return distanceBetween(node1: player, node2: first) < distanceBetween(node1: player, node2: second)
       }).first else {return}
        
        let time = distanceBetween(node1: player, node2: closestEnemy) / Float(spd * spd)
        let movement = SKAction.move(to: closestEnemy.position,duration: TimeInterval(time))
        playSound(audioFileName: "BULLETS.mp3")
        let sequence = SKAction.sequence([movement, .removeFromParent()])
           shot.run(sequence)
        
    }
    
    func playSound(audioFileName: String){
        let soundNode = SKAudioNode(fileNamed: audioFileName)
        soundNode.autoplayLooped = false
        addChild(soundNode)
        if(gameLogic.soundsSwitch){
            soundNode.run(SKAction.changeVolume(to: (0.07/5)*Float(gameLogic.soundsVolume), duration: 0))
        }else{
            soundNode.run(SKAction.changeVolume(to: 0, duration: 0))
        }
        let playSound = SKAction.run {
                soundNode.run(SKAction.play())
            }
        
        let sequence = SKAction.sequence([playSound, .removeFromParent()])
        self.scene?.run(sequence)
    }
}
