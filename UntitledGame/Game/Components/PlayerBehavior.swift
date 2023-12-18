//
//  ShotLogic.swift
//  UntitledGame
//
//  Created by Linar Zinatullin on 13/12/23.
//

import Foundation
import SpriteKit

extension GameScene{
    
    func shoot(){
        guard !isGameOver else {return}
        let shot = SKSpriteNode(imageNamed: "bullet")
        shot.texture?.filteringMode = .nearest
        shot.name = "bullet"
        shot.position = player.position
        let spriteAtlas = SKTextureAtlas(named: "AntiTank/Fire")
        var textures: [SKTexture] = []
        spriteAtlas.textureNames.forEach { string in
            let texture = spriteAtlas.textureNamed(string)
            texture.filteringMode = .nearest
            textures.append(texture)
        }
        
        let shootAnimation = SKAction.animate(with: textures, timePerFrame: 0.1)
        player.run(shootAnimation)
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
