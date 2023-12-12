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
        player.userData = ["level": 1, "xp": 0, "xpToNextLevel": 30];
        player.zPosition = 2
        player.physicsBody?.categoryBitMask = CollisionType.player
        player.physicsBody?.collisionBitMask = CollisionType.enemy
        player.physicsBody?.contactTestBitMask = CollisionType.enemy
        player.physicsBody?.isDynamic = false
        self.player.physicsBody?.affectedByGravity = false
        addChild(self.player)
    }
    
    public func levelUp(){
        player.userData!["level"] = (player.userData!["level"] as? Int)! + 1
        let nextLevelXp = (player.userData!["xpToNextLevel"] as? Int)! + 10
        player.userData!["xpToNextLevel"] = nextLevelXp
        gameLogic.xpToNextLvl = nextLevelXp
        player.userData!["xp"] = 0
        
        //prints to check from console
        print("Reached new level!")
        print(player.userData!["level"]!)
        print("Xp needed to level up")
        print(player.userData!["xpToNextLevel"]!)
        print("current xp")
        print(player.userData!["xp"]!)
    }
}
