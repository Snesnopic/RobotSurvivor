//
//  ShotLogic.swift
//  UntitledGame
//
//  Created by Linar Zinatullin on 13/12/23.
//

import Foundation
import SpriteKit
import AVFAudio
import CoreHaptics

extension GameScene{
    
    //leveling up
    
    func levelUp(){
        player.level += 1
        player.xp = 0
        player.xpToNextLevel += 10
        gameLogic.xpToNextLvl = player.xpToNextLevel
        gameLogic.playerLevel += 1
        gameLogic.showPowerUp = true
    }
    
    //whenever the +hp power up is called, this updates the maximum hp, although visually the bar will always appear kind of buggy, in fact, if you pick up +hp as first powerup, you will see the bar 1/4 empty
    public func updateHpBar() {
        let healthBarFill = healthBar.children.last!
        healthBarFill.xScale = CGFloat(Double(player.hp) / Double(player.maxHp))
    }
    
    //basically to make this game lighter, it's important to reuse assets since the bullets and the sounds get called a lot in the update function, therefore i created an array of both bullets and sounds in which the game extracts the nodes.
    func setupBulletPool(quantityOfBullets: Int) {
        for _ in 0..<quantityOfBullets {
            let bullet = SKSpriteNode(imageNamed: "bullet")
            configureBullet(bullet)
            configureBulletPhysics(bullet)
            bulletPool.append(bullet)
        }
    }
    //this is to setup the sound pool for bullets
    func setUpSoundPoolForBullets() {
        if let soundURL = Bundle.main.url(forResource: "BULLETS", withExtension: "mp3") {
            for _ in 0..<maxConcurrentSounds {
                let audioNode = SKAudioNode(url: soundURL)
                audioNode.autoplayLooped = false
                audioNode.name = "BULLET"
                addChild(audioNode)
                bulletSoundNodes.append(audioNode)
            }
        }
    }
    //this is the extraction part of the bullets
    func getBulletFromPool() -> SKSpriteNode? {
        if bulletPool.isEmpty {
            setupBulletPool(quantityOfBullets: 10)
        }
        return bulletPool.popLast()
    }
    
    //and after the lifecycle of the bullet ended, it gets back into the array
    func returnBulletToPool(_ bullets: [SKSpriteNode]) {
        bulletPool.append(contentsOf: bullets)
    }
    
    //this plays the sound
    func playBulletSound() {
        let audioNode = bulletSoundNodes[currentIndex]
        audioNode.run(SKAction.changeVolume(to: gameLogic.soundsSwitch ? (0.05/5) * Float(gameLogic.soundsVolume) : 0, duration: 0))
        audioNode.run(SKAction.play())
        currentIndex = (currentIndex + 1) % maxConcurrentSounds
    }
    
    //for the same purpose of the sounds, the hitting sounds and others may be used with the same logic
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
    
    func playShortSound(name: String) {

        guard let soundPlayer = soundPool.first else { return }
        soundPlayer.volume = gameLogic.soundsSwitch ? (0.2/5) * Float(gameLogic.soundsVolume) : 0
        soundPool.removeFirst()
        soundPlayer.play()
        soundPool.append(soundPlayer)
        
        //whenever the sound gets played, the user feels the impact with the haptic
        if let playerGettingHitHaptic = createHitHapticPattern() {
            do {
                let player = try hapticEngine?.makePlayer(with: playerGettingHitHaptic)
                try player?.start(atTime: 0)
            } catch {
                print("Ascanio: \(error.localizedDescription)")
            }
        }
    }
    
    //this plays the getting hit sound
    func playGettingHitSound(name: String) {

        guard let soundPlayer = soundPool.first else { return }
        soundPlayer.volume = gameLogic.soundsSwitch ? (0.2/5) * Float(gameLogic.soundsVolume) : 0
        soundPool.removeFirst()
        soundPlayer.play()
        soundPool.append(soundPlayer)
        
        //whenever the sound gets played, the user feels the impact with the haptic
        if let playerGettingHitHaptic = createHitHapticPattern() {
            do {
                let player = try hapticEngine?.makePlayer(with: playerGettingHitHaptic)
                try player?.start(atTime: 0)
            } catch {
                print("Ascanio: \(error.localizedDescription)")
            }
        }
    }
    
    //these are for configuration of bullet node
    private func configureBullet(_ bullet: SKSpriteNode) {
        bullet.texture?.filteringMode = .nearest
        bullet.name = "bullet"
        bullet.zPosition = 2
        bullet.setScale(1.5)
    }
    
    //these configures the physics of the bullet
    private func configureBulletPhysics(_ bullet: SKSpriteNode) {
        bullet.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: bullet.size.width/3, height: bullet.size.height/3))
        bullet.physicsBody?.categoryBitMask = CollisionType.playerWeapon
        bullet.physicsBody?.collisionBitMask = CollisionType.enemy
        bullet.physicsBody?.contactTestBitMask = CollisionType.enemy
        bullet.physicsBody?.isDynamic = false
    }
    
    //this should be explained by casillo
    func findClosestEnemy() -> EnemyNode? {
        let activeEnemies = children.compactMap { $0 as? EnemyNode }
        return activeEnemies.min(by: {
            distanceBetween(node1: player, node2: $0) < distanceBetween(node1: player, node2: $1)
        })
    }
    
    //find closest enemy
    func distanceBetween(node1: SKNode, node2: SKNode) -> Float {
        return hypotf(Float(node1.position.x - node2.position.x), Float(node1.position.y - node2.position.y))
    }
    
    //this uses almost everything in this file
    func shoot() {
        var usedBullets: [SKSpriteNode] = []
        guard !isGameOver else { return }
        
        if let shot = getBulletFromPool() {
            print("colpi nel vettore: \(bulletPool.count)")
            usedBullets.append(shot)
            shot.position = player.position
            addChild(shot)
            
            if let closestEnemy = findClosestEnemy() {
                let time = distanceBetween(node1: player, node2: closestEnemy) / min(Float(spd * 10), 400)
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
            
            //this is for the firerate power up
            let maxFireRate = max(fireRate, 0.001)
            let waitAction = SKAction.wait(forDuration: 1.0 / maxFireRate)
            let enableShootingAction = SKAction.run {
                self.readyToShoot = true
            }

            let sequence = SKAction.sequence([waitAction, enableShootingAction])
            run(sequence)
        }
    }
    
    //play death sound as explained above
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
    
    func createHitHapticPattern() -> CHHapticPattern? {
        do {
            let hapticEvent = CHHapticEvent(
                eventType: .hapticContinuous,
                parameters: [
                    //tweak these for intensity and sharpness
                    CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.5),
                    CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.3)
                ],
                //tweak these for duration
                relativeTime: 0,
                duration: 0.1
            )
            return try CHHapticPattern(events: [hapticEvent], parameters: [])
        } catch {
            print("Failed to create haptic pattern: \(error.localizedDescription)")
            return nil
        }
    }

}
