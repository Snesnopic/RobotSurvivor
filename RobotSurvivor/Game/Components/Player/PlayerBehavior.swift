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
        player.level += 1
        player.xp = 0
        player.xpToNextLevel += 10
        gameLogic.xpToNextLvl = player.xpToNextLevel
        
        gameLogic.showPowerUp = true
    }
    
    func setupBulletPool(quantityOfBullets: Int) {
        for _ in 0..<quantityOfBullets { 
            let bullet = SKSpriteNode(imageNamed: "bullet")
            configureBullet(bullet)
            configureBulletPhysics(bullet)
            bulletPool.append(bullet)
        }
    }
    
    func getBulletFromPool() -> SKSpriteNode? {
        
        //TODO: da ottimizzare, magari facendo solo questo if, ma adesso non ho sbatti
        if (bulletPool.count < 10 && !done) {
            DispatchQueue.global(qos: .background).async {
                self.setupBulletPool(quantityOfBullets: 50)
            }
            done = true;
        } else {
            done = false
        }
        return bulletPool.removeLast()
    }

    public func updateHpBar() {
        let healthBarFill = healthBar.children.last!
        healthBarFill.xScale = CGFloat(Double(player.hp) / Double(player.maxHp))
    }
    
    func returnBulletToPool(_ bullets: [SKSpriteNode]) {
        
        //TODO: da ottimizzare, vedi func precedente
        for bullet in bullets {
            bulletPool.append(bullet)
        }
    }
        
    func shoot() {
        
        var usedBullets: [SKSpriteNode] = []
        guard !isGameOver else { return }
        
        if let shot = getBulletFromPool() {
            
            usedBullets.append(shot)
            shot.position = player.position
            addChild(shot)
            
            print("Proiettili restanti: \(bulletPool.count)")

            if let closestEnemy = findClosestEnemy() {
                let time = distanceBetween(node1: player, node2: closestEnemy) / Float(spd * 8)
                let movement = SKAction.move(to: closestEnemy.position, duration: TimeInterval(time))
                
                playBulletSound(name: "BULLETS")
                player.run(shootAnimation)
                
                let sequence = SKAction.sequence([movement, .removeFromParent()])
                
                shot.run(sequence) { [self] in
                    if usedBullets.last == shot {
                        self.returnBulletToPool(usedBullets)
                        print("Rimetto proiettile: \(bulletPool.count)")
                    }
                }
            }
        }
    }
    
    
    func setupBulletSoundPool(quantityOfSounds: Int) {

        for _ in 0..<quantityOfSounds {
            if let soundURL = Bundle.main.url(forResource: "BULLETS", withExtension: "mp3") {
                do {
                    let soundPlayer = try AVAudioPlayer(contentsOf: soundURL)
                    soundPlayer.prepareToPlay()
                    self.bulletSoundPool.append(soundPlayer)
                } catch {
                    print("mammt dice: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func playBulletSound(name: String) {
        
        guard let soundPlayer = bulletSoundPool.first else { return }
        soundPlayer.volume = gameLogic.soundsSwitch ? (0.15/5) * Float(gameLogic.soundsVolume) : 0
        bulletSoundPool.removeFirst()
        soundPlayer.play()
        bulletSoundPool.append(soundPlayer)
    }
    
    func setupShortSoundPool(name soundName: String, quantityOfSounds: Int) {
        
        let soundURL = Bundle.main.url(forResource: soundName, withExtension: "mp3")
        
        do {
            let soundPlayer = try AVAudioPlayer(contentsOf: soundURL!)
            soundPlayer.prepareToPlay()
            
            for _ in 0..<quantityOfSounds {
                self.soundPool.append(soundPlayer)
            }
        } catch {
            print("Ascanio dice: \(error.localizedDescription)")
        }
    }
    
    func playGettingHitSound(name: String) {
        
        guard let soundPlayer = soundPool.first else { return }
        soundPlayer.volume = gameLogic.soundsSwitch ? (0.2/5) * Float(gameLogic.soundsVolume) : 0
        soundPool.removeFirst()
        soundPlayer.play()
        soundPool.append(soundPlayer)
    }
    
    func configureBullet(_ bullet: SKSpriteNode) {
        bullet.texture?.filteringMode = .nearest
        bullet.name = "bullet"
        bullet.position = player.position
        player.run(shootAnimation)
        bullet.zPosition = 2
        bullet.setScale(1.5)
    }
    
    func configureBulletPhysics(_ bullet: SKSpriteNode) {
        bullet.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: bullet.size.width/3, height: bullet.size.height/3))
        bullet.physicsBody?.categoryBitMask = CollisionType.playerWeapon
        bullet.physicsBody?.collisionBitMask = CollisionType.enemy
        bullet.physicsBody?.contactTestBitMask = CollisionType.enemy
        bullet.physicsBody?.isDynamic = false
    }

    func findClosestEnemy() -> EnemyNode? {
        let activeEnemies = children.compactMap { $0 as? EnemyNode }
        return activeEnemies.min(by: { distanceBetween(node1: player, node2: $0) < distanceBetween(node1: player, node2: $1) })
    }

    func playDeathSound(audioFileName: String){
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
