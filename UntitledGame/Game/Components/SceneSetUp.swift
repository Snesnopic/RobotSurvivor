//
//  SceneSetUp.swift
//  UntitledGame
//
//  Created by Linar Zinatullin on 07/12/23.
//

import Foundation
import SpriteKit

extension GameScene {
    
    func setUpGame() {
        self.gameLogic.setUpGame()
        self.setUpPhysicsWorld()
        self.backgroundColor = SKColor.darkGray
        let playerInitialPosition = CGPoint(x: self.frame.width/2, y: self.frame.height/2)
        self.createPlayer(at: playerInitialPosition)
        self.camera = sceneCamera
    }
    
    private func setUpPhysicsWorld() {
        // TODO: Customize!
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = .zero
        
    }
    
    private func createPlayer(at position: CGPoint) {
        self.player.name = "player"
        
        player.size = (player.texture?.size())!
        self.player.position = position
        
        player.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: player.texture!.size().width, height:  (player.texture?.size().height)!))
        player.userData = ["level": 1, "xp": 0, "xpToNextLevel": 30, "speed": 80, "hp": 100, "maxhp": 100];
        player.zPosition = 2
        player.physicsBody?.categoryBitMask = CollisionType.player
        player.physicsBody?.collisionBitMask = CollisionType.enemy
        player.physicsBody?.contactTestBitMask = CollisionType.enemy
        player.physicsBody?.isDynamic = false
        self.player.physicsBody?.affectedByGravity = false
        
        healthBar = SKScene()
        
        let healthBarFill = SKShapeNode(rect: CGRect(origin: player.position, size: CGSize(width: player.size.width, height: 10.0)))
        let healthBarTotal = SKShapeNode(rect: CGRect(origin: player.position, size: CGSize(width: player.size.width, height: 10.0)))
        
        healthBarTotal.fillColor = UIColor(red: 0.54, green: 0.0, blue: 0.0, alpha: 1.0)
        healthBarFill.fillColor = UIColor.red
        
        healthBarTotal.strokeColor = UIColor(red: 0.54, green: 0.0, blue: 0.0, alpha: 1.0)
        healthBarFill.strokeColor = UIColor.red
        
        print("Health bar position: \(healthBarFill.position)")
        print("Player position: \(player.position)")
        
        let array = [healthBarFill,healthBarTotal]
        array.forEach { node in
            node.position.x = node.position.x - (player.size.width / 2)
            node.position.y = node.position.y - player.size.height
        }
        
        healthBar.addChild(healthBarTotal)
        healthBar.addChild(healthBarFill)
        addChild(healthBar)
        addChild(self.player)
    }
    
    public func levelUp(){
        player.userData!["level"] = (player.userData!["level"] as? Int)! + 1
        player.userData!["xp"] = 0
        let nextLevelXp = (player.userData!["xpToNextLevel"] as? Int)! + 10
        player.userData!["xpToNextLevel"] = nextLevelXp
        gameLogic.xpToNextLvl = nextLevelXp
        
        gameLogic.showPowerUp = true
        
        //prints to check from console
        print("Reached new level!")
        print(player.userData!["level"]!)
        print("Xp needed to level up")
        print(player.userData!["xpToNextLevel"]!)
        print("current xp")
        print(player.userData!["xp"]!)
    }
}
