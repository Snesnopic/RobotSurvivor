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
        player = SKSpriteNode(imageNamed: "\(gameLogic.currentSkin)/Idle/1")
        player.name = "player"
        player.run(SKAction.repeatForever(playerIdleAnimation))
        player.size = CGSize(width: 30, height: 30)
        self.player.position = position
        player.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 20, height:  20))
        player.userData = ["level": 1, "xp": 0, "xpToNextLevel": 10, "speed": 70, "hp": 100, "maxhp": 100];
        player.zPosition = 3
        player.position = CGPoint(x: 0, y: 0)
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
