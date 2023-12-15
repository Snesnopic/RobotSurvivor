//
//  ShotLogic.swift
//  UntitledGame
//
//  Created by Linar Zinatullin on 13/12/23.
//

import Foundation
import SpriteKit

extension GameScene{
    
    
    
    func shoot(speed: Int){
        guard !isGameOver else {return}
        let shot = SKSpriteNode(imageNamed: "bullet")
        shot.texture?.filteringMode = .nearest
        shot.name = "bullet"
        shot.position = player.position
        
        shot.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: shot.size.width/2, height: shot.size.height/2))
        shot.physicsBody?.categoryBitMask = CollisionType.playerWeapon
        shot.physicsBody?.collisionBitMask =  CollisionType.enemy
        shot.physicsBody?.contactTestBitMask = CollisionType.enemy
        shot.physicsBody?.isDynamic = false
        shot.zPosition = 2
        shot.setScale(2)
        addChild(shot)
        let activeEnemies: [EnemyNode] = children.filter { node in
            return node.isKind(of: EnemyNode.classForCoder())
        } as! [EnemyNode]
        let closestEnemy: EnemyNode = activeEnemies.sorted(by: { first, second in
            return distanceBetween(node1: player, node2: first) < distanceBetween(node1: player, node2: second)
        }).first!
        let time = distanceBetween(node1: player, node2: closestEnemy) / Float(speed * speed)
        let movement = SKAction.move(to: closestEnemy.position,duration: TimeInterval(time))
        
        let soundNode = SKAudioNode(fileNamed: "BULLETS.mp3")
        soundNode.autoplayLooped = false
        addChild(soundNode)
        soundNode.run(SKAction.changeVolume(to: 0.1, duration: 0))
        
        let playSound = SKAction.run {
                soundNode.run(SKAction.play())
            }
        
        
        let sequence = SKAction.sequence([playSound, movement, .removeFromParent()])
           shot.run(sequence)
        
    }
}
