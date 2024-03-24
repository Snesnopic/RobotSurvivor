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
        gameLogic.playerLevel += 1
        gameLogic.showPowerUp = true
    }
    public func updateHpBar() {
        let healthBarFill = healthBar.children.last!
        healthBarFill.xScale = CGFloat(Double(player.hp) / Double(player.maxHp))
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
        if bulletPool.isEmpty {
            setupBulletPool(quantityOfBullets: 50) // Replenish the pool if empty
        }
        return bulletPool.popLast()
    }
    
    func returnBulletToPool(_ bullets: [SKSpriteNode]) {
        bulletPool.append(contentsOf: bullets)
    }
    
    func setupBulletSoundPool(quantityOfSounds: Int) {
        for _ in 0..<quantityOfSounds {
            if let soundURL = Bundle.main.url(forResource: "BULLETS", withExtension: "mp3") {
                do {
                    let soundPlayer = try AVAudioPlayer(contentsOf: soundURL)
                    soundPlayer.prepareToPlay()
                    bulletSoundPool.append(soundPlayer)
                } catch {
                    print("Error loading bullet sound: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func playBulletSound() {
        guard let soundPlayer = getAvailableSoundPlayer() else {
            print("No available sound player in the pool")
            return
        }
        
        soundPlayer.volume = gameLogic.soundsSwitch ? (0.1/5) * Float(gameLogic.soundsVolume) : 0
        soundPlayer.play()
    }

    func getAvailableSoundPlayer() -> AVAudioPlayer? {

        for sound in bulletSoundPool {
            if !sound.isPlaying {
                return sound
            }
        }
        if bulletSoundPool.count < max(Int(fireRate) + 1, 10) {
            do {
                if let soundURL = Bundle.main.url(forResource: "BULLETS", withExtension: "mp3") {
                    let newSoundPlayer = try AVAudioPlayer(contentsOf: soundURL)
                    newSoundPlayer.prepareToPlay()
                    bulletSoundPool.append(newSoundPlayer)
                    return newSoundPlayer
                } else {
                    print("Failed to find sound file")
                }
            } catch {
                print("Error creating AVAudioPlayer: \(error.localizedDescription)")
            }
        }
        return nil
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
    
    private func configureBullet(_ bullet: SKSpriteNode) {
        bullet.texture?.filteringMode = .nearest
        bullet.name = "bullet"
        bullet.zPosition = 2
        bullet.setScale(1.5)
    }
    
    private func configureBulletPhysics(_ bullet: SKSpriteNode) {
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
    
    func shoot() {
        var usedBullets: [SKSpriteNode] = []
        guard !isGameOver else { return }
        
        if let shot = getBulletFromPool() {
            print("colpi nel vettore: \(bulletPool.count)")
            usedBullets.append(shot)
            shot.position = player.position
            addChild(shot)
            
            if let closestEnemy = findClosestEnemy() {
                let time = distanceBetween(node1: player, node2: closestEnemy) / max(Float(spd * 10), 400)
                let movement = SKAction.move(to: closestEnemy.position, duration: TimeInterval(time))
                
                playBulletSound()
                player.run(shootAnimation)
                
                let sequence = SKAction.sequence([movement, .removeFromParent()])
                
                shot.run(sequence) { [self] in
                    if usedBullets.last == shot {
                        returnBulletToPool(usedBullets)
                        print("colpi aggiornati vettore: \(bulletPool.count)")
                    }
                }
            }
        }
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
