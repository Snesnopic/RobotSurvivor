//
//  PlayerSetUp.swift
//  Robot Survivor
//
//  Created by Giuseppe Casillo on 21/12/23.
//

import Foundation
import SpriteKit

extension GameScene{
    func createPlayer(at position: CGPoint) {
        
        self.player = SKSpriteNode(imageNamed: "AntiTank/Idle/1")
        self.player.name = "player"
        var playerAtlas: SKTextureAtlas {
            return SKTextureAtlas(named: "AntiTank/Idle")
        }
        var playerIdleTextures: [SKTexture] = []
        playerAtlas.textureNames.forEach { string in
            let texture = playerAtlas.textureNamed(string)
            texture.filteringMode = .nearest
            playerIdleTextures.append(texture)
        }
        
        let idleAnimation = SKAction.animate(with: playerIdleTextures, timePerFrame: 0.3)
        player.run(SKAction.repeatForever(idleAnimation))
        player.size = CGSize(width: 30, height: 30)
        self.player.position = position
        player.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 20, height:  20))
        player.userData = ["level": 1, "xp": 0, "xpToNextLevel": 30, "speed": 70, "hp": 100, "maxhp": 100];
        player.zPosition = 3
        player.physicsBody?.categoryBitMask = CollisionType.player
        player.physicsBody?.collisionBitMask = CollisionType.enemy
        player.physicsBody?.contactTestBitMask = CollisionType.enemy
        player.physicsBody?.isDynamic = false
        
        self.player.physicsBody?.affectedByGravity = false
        healthBar = SKScene()
        
        let healthBarFill = SKShapeNode(rect: CGRect(origin: .zero, size: CGSize(width: player.size.width, height: 5.0)))
        let healthBarTotal = SKShapeNode(rect: CGRect(origin: .zero, size: CGSize(width: player.size.width, height: 5.0)))
        
        healthBarTotal.fillColor = UIColor(red: 0.54, green: 0.0, blue: 0.0, alpha: 1.0)
        healthBarFill.fillColor = UIColor.red
        
        healthBarTotal.strokeColor = UIColor(red: 0.54, green: 0.0, blue: 0.0, alpha: 1.0)
        healthBarFill.strokeColor = UIColor.red
        
        healthBarTotal.zPosition = 2
        healthBarFill.zPosition = healthBarTotal.zPosition + 1
        
        healthBar.addChild(healthBarTotal)
        healthBar.addChild(healthBarFill)
        
        healthBar.children.forEach { node in
            node.position = player.position
            node.position.x = node.position.x - (player.size.width / 2)
            node.position.y = node.position.y - player.size.height
        }
        
        addChild(healthBar)
        addChild(self.player)
    }
    
}
