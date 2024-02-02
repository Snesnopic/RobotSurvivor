//
//  ShotLogic.swift
//  UntitledGame
//
//  Created by Linar Zinatullin on 13/12/23.
//

import Foundation
import SpriteKit
import AVFAudio

extension GameScene{
    
    func levelUp(){
        player.userData!["level"] = (player.userData!["level"] as? Int)! + 1
        player.userData!["xp"] = 0
        let nextLevelXp = (player.userData!["xpToNextLevel"] as? Int)! + 10
        player.userData!["xpToNextLevel"] = nextLevelXp
        gameLogic.xpToNextLvl = nextLevelXp
        
        gameLogic.showPowerUp = true
    }
    
//    func shoot(){
//        guard !isGameOver else {return}
//        let shot = SKSpriteNode(imageNamed: "bullet")
//        shot.texture?.filteringMode = .nearest
//        shot.name = "bullet"
//        shot.position = player.position
//        player.run(shootAnimation)
//        shot.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: shot.size.width/3, height: shot.size.height/3))
//        shot.physicsBody?.categoryBitMask = CollisionType.playerWeapon
//        shot.physicsBody?.collisionBitMask =  CollisionType.enemy
//        shot.physicsBody?.contactTestBitMask = CollisionType.enemy
//        shot.physicsBody?.isDynamic = false
//        shot.zPosition = 2
//        shot.setScale(1.5)
//        addChild(shot)
//        
//        let activeEnemies = children.compactMap{$0 as? EnemyNode}
//       guard let closestEnemy: EnemyNode = activeEnemies.sorted(by: { first, second in
//            return distanceBetween(node1: player, node2: first) < distanceBetween(node1: player, node2: second)
//       }).first else {return}
//        
//        let time = distanceBetween(node1: player, node2: closestEnemy) / Float(spd * spd)
//        let movement = SKAction.move(to: closestEnemy.position,duration: TimeInterval(time))
//        playSound(audioFileName: "BULLETS.mp3")
//        let sequence = SKAction.sequence([movement, .removeFromParent()])
//           shot.run(sequence)
//        
//    }
    
//    func shoot() {
//        guard !isGameOver else { return }
//
//        let shot = SKSpriteNode(imageNamed: "bullet")
//        shot.texture?.filteringMode = .nearest
//        shot.name = "bullet"
//        shot.position = player.position
//        shot.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: shot.size.width, height: shot.size.height))
//        shot.physicsBody?.categoryBitMask = CollisionType.playerWeapon
//        shot.physicsBody?.collisionBitMask = CollisionType.enemy
//        shot.physicsBody?.contactTestBitMask = CollisionType.enemy
//        shot.physicsBody?.isDynamic = false
//        shot.zPosition = 2
//        addChild(shot)
//        
//        let activeEnemies = children.compactMap { $0 as? EnemyNode }
//        guard let closestEnemy = activeEnemies.min(by: { distanceBetween(node1: player, node2: $0) < distanceBetween(node1: player, node2: $1) }) else {
//            return
//        }
//
//        let time = distanceBetween(node1: player, node2: closestEnemy) / Float(spd * spd)
//        let movement = SKAction.move(to: closestEnemy.position, duration: TimeInterval(time))
//        let remove = SKAction.removeFromParent()
//
//        // Combine movement and removal actions into a sequence
//        let sequence = SKAction.sequence([movement, remove])
//
//        // Create recoil animation (move player back briefly)
//        let recoilDistance: CGFloat = 50.0
//        let recoilAction = SKAction.move(by: CGVector(dx: -recoilDistance, dy: 0), duration: 1/fireRate)
//        let resetPositionAction = SKAction.move(by: CGVector(dx: 0, dy: recoilDistance), duration: 1/fireRate)
//
//        // Combine the recoil animation with the shooting sequence
//        let combinedAction = SKAction.group([sequence, recoilAction, resetPositionAction])
//
//        playSound(audioFileName: "BULLETS.mp3")
//
//        // Run the combined action on the shot
//        shot.run(combinedAction)
//    }
    
    func setupSoundBullet() {
        // Chiamato per inizializzare il pool dei suoni
        for _ in 0..<100 {
            if let soundURL = Bundle.main.url(forResource: "BULLETS", withExtension: "mp3") {
                do {
                    let soundPlayer = try AVAudioPlayer(contentsOf: soundURL)
                    soundPlayer.prepareToPlay()
                    soundPool.append(soundPlayer)
                } catch {
                    print("mammt: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func playGunshotSound() {
            guard let soundPlayer = soundPool.first else {
                return
            }
            soundPlayer.volume = gameLogic.soundsSwitch ? (0.2/5) * Float(gameLogic.soundsVolume) : 0
            soundPool.removeFirst()
            soundPlayer.play()
            soundPool.append(soundPlayer)
        
        }
    
    func shoot() {
        guard !isGameOver else { return }
        
        //setup
        let shot = SKSpriteNode(imageNamed: "bullet")
        configureBullet(shot)
        configureBulletPhysics(shot)
        addChild(shot)

        if let closestEnemy = findClosestEnemy() {
            let time = distanceBetween(node1: player, node2: closestEnemy) / Float(spd * spd)
            let movement = SKAction.move(to: closestEnemy.position, duration: TimeInterval(time))
            
            // Run shooting animation and movement sequence
            player.run(shootAnimation)
//            playSound(audioFileName: "BULLETS.mp3")
            playGunshotSound()
            let sequence = SKAction.sequence([movement, .removeFromParent()])
            shot.run(sequence)
        }
    }
    
    //per i proiettili
    func configureBullet(_ bullet: SKSpriteNode) {
        bullet.texture?.filteringMode = .nearest
        bullet.name = "bullet"
        bullet.position = player.position
        player.run(shootAnimation)
        bullet.zPosition = 2
        bullet.setScale(1.5)
    }
    
    //per la fisica dei proiettili
    func configureBulletPhysics(_ bullet: SKSpriteNode) {
        bullet.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: bullet.size.width/3, height: bullet.size.height/3))
        bullet.physicsBody?.categoryBitMask = CollisionType.playerWeapon
        bullet.physicsBody?.collisionBitMask = CollisionType.enemy
        bullet.physicsBody?.contactTestBitMask = CollisionType.enemy
        bullet.physicsBody?.isDynamic = false
    }

    //ricerca
    func findClosestEnemy() -> EnemyNode? {
        let activeEnemies = children.compactMap { $0 as? EnemyNode }
        return activeEnemies.min(by: { distanceBetween(node1: player, node2: $0) < distanceBetween(node1: player, node2: $1) })
    }

    //per l'audio
    func playSound(audioFileName: String){
        let soundNode = SKAudioNode(fileNamed: audioFileName)
        soundNode.autoplayLooped = false
        addChild(soundNode)
        
        let volume = gameLogic.soundsSwitch ? (0.07/5) * Float(gameLogic.soundsVolume) : 0
        soundNode.run(SKAction.changeVolume(to: volume, duration: 0))

        let playSound = SKAction.run {
                soundNode.run(SKAction.play())
            }
        
        let sequence = SKAction.sequence([playSound, .removeFromParent()])
        self.scene?.run(sequence)
    }
}
