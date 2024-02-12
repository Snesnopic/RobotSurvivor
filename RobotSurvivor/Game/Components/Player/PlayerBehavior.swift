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
    
    //il motivo per il quale questa soluzione è ottimale è il fatto che prima si generava un proiettile su richiesta del main thread. Adesso si inizializza una funzione che è un buffer di proiettili, che poi viene caricata asincronamente così da alleggerire notevolmente la computazione.
    
    //TLDR: ottimizza notevolmente il gioco
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
        let playerMaxHp:Double = player.userData!["maxhp"] as! Double
        guard let playerHp:Double = player.userData!["hp"] as? Double else {return}
        healthBarFill.xScale = CGFloat(playerHp  / playerMaxHp)
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
            
            //ue uaglio bell stu proiettile
            usedBullets.append(shot)
            shot.position = player.position
            addChild(shot)
            
            print("Proiettili restanti: \(bulletPool.count)")

            if let closestEnemy = findClosestEnemy() {
                let time = distanceBetween(node1: player, node2: closestEnemy) / Float(spd * 8)
                let movement = SKAction.move(to: closestEnemy.position, duration: TimeInterval(time))
                
                //PEW PEW
                playBulletSound(name: "BULLETS")
                //SPAR LELLU' SPAR
                player.run(shootAnimation)
                
                let sequence = SKAction.sequence([movement, .removeFromParent()])
                
                shot.run(sequence) { [self] in
                    if usedBullets.last == shot {
                        //tie piglt o proiettile
                        self.returnBulletToPool(usedBullets)
                        print("Rimetto proiettile: \(bulletPool.count)")
                    }
                }
            }
        }
    }
    
    //il motivo per il quale questa soluzione è ottimale è il fatto che prima si generava un suono (musica, suono colpi) su richiesta del main thread. Adesso si inizializza una funzione che è un buffer di suoni, che poi viene caricata asincronamente (in funzione dei suoni) così da alleggerire notevolmente la computazione.
    
    //TLDR: ottimizza notevolmente il gioco
    func setupBulletSoundPool(quantityOfSounds: Int) {
        //Inizializza la pool dei suoni
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
    
    //perché 2? Per lo stesso motivo
    func playBulletSound(name: String) {
        
        guard let soundPlayer = bulletSoundPool.first else { return }
        soundPlayer.volume = gameLogic.soundsSwitch ? (0.05/5) * Float(gameLogic.soundsVolume) : 0
        bulletSoundPool.removeFirst()
        soundPlayer.play()
        bulletSoundPool.append(soundPlayer)
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
