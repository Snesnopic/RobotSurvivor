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
    
    //il motivo per il quale questa soluzione è ottimale è il fatto che prima si generava un suono (musica, suono colpi) su richiesta del main thread. Adesso si inizializza una funzione che è un array di suoni, che poi viene caricata asincronamente (in funzione dei suoni) così da alleggerire notevolmente la computazione.
    
    
    func setupBulletPool(quantityOfBullets: Int) {
        for _ in 0..<quantityOfBullets { 
            let bullet = SKSpriteNode(imageNamed: "bullet")
            configureBullet(bullet)
            configureBulletPhysics(bullet)
            bulletPool.append(bullet)
        }
    }
    
    func getBulletFromPool() -> SKSpriteNode? { return bulletPool.isEmpty ? nil : bulletPool.removeLast() }
    func returnBulletToPool(_ bullet: SKSpriteNode) { bulletPool.append(bullet) }
        
    func shoot() {
        guard !isGameOver else { return }
        
        if let shot = getBulletFromPool() {
            // Imposta la posizione iniziale del proiettile in base alla posizione del giocatore
            shot.position = player.position
            addChild(shot)
            
            print("Numero di proiettili: \(bulletPool.count)")
            
            if let closestEnemy = findClosestEnemy() {
                let time = distanceBetween(node1: player, node2: closestEnemy) / Float(spd * spd)
                let movement = SKAction.move(to: closestEnemy.position, duration: TimeInterval(time))
                
                // Play sound before shooting animation and movement sequence
                playShotSound(name: "BULLETS")
                player.run(shootAnimation)
                
                let sequence = SKAction.sequence([movement, .removeFromParent()])
                
                // Restituisci il proiettile alla pool dopo il completamento della sequenza
                shot.run(sequence) { [self] in
                    print("Numero di proiettili: \(bulletPool.count)")
                    self.returnBulletToPool(shot)
                    print("Rimetto proiettile: \(bulletPool.count)")
                }
            }
        }
    }

    //TLDR: ottimizza notevolmente il gioco
    func setupShotPool(quantityOfSounds: Int) {
        //Inizializza la pool dei suoni
        for _ in 0..<quantityOfSounds {
            if let soundURL = Bundle.main.url(forResource: "BULLETS", withExtension: "mp3") {
                do {
                    let soundPlayer = try AVAudioPlayer(contentsOf: soundURL)
                    soundPlayer.prepareToPlay()
                    self.shotSoundPool.append(soundPlayer)
                } catch {
                    print("mammt dice: \(error.localizedDescription)")
                }
            }
        }
    }
    
    //perché 2? Per lo stesso motivo
    func playShotSound(name: String) {
        
        guard let soundPlayer = shotSoundPool.first else { return }
        soundPlayer.volume = gameLogic.soundsSwitch ? (0.05/5) * Float(gameLogic.soundsVolume) : 0
        print("Rimuovo suono, numero attuale: \(shotSoundPool.count)")
        shotSoundPool.removeFirst()
        soundPlayer.play()
        print("Suono utilizzato, rimetto suono. Numero attuale: \(shotSoundPool.count)")
        shotSoundPool.append(soundPlayer)
        print("Suono rimesso. Numero suoni totali: \(shotSoundPool.count)")
    }
    
    func setupShortSoundPool(name soundName: String, quantityOfSounds: Int) {
        
        let soundURL = Bundle.main.url(forResource: soundName, withExtension: "mp3")
        
        do {
            let soundPlayer = try AVAudioPlayer(contentsOf: soundURL!)
            soundPlayer.prepareToPlay()
            
            //Inizializza la pool dei suoni
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
    
//    func shoot() {
//        guard !isGameOver else { return }
//        
//        //setup
//        let shot = SKSpriteNode(imageNamed: "bullet")
//        configureBullet(shot)
//        configureBulletPhysics(shot)
//        addChild(shot)
//        
//        if let closestEnemy = findClosestEnemy() {
//            let time = distanceBetween(node1: player, node2: closestEnemy) / Float(spd * spd)
//            let movement = SKAction.move(to: closestEnemy.position, duration: TimeInterval(time))
//            
//            // Run shooting animation and movement sequence
//            player.run(shootAnimation)
//            //            playSound(audioFileName: "BULLETS.mp3")
//            playShotSound(name: "BULLETS")
//            let sequence = SKAction.sequence([movement, .removeFromParent()])
//            shot.run(sequence)
//        }
//    }
    
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
