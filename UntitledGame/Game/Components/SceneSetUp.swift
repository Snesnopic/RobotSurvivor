//
//  SceneSetUp.swift
//  UntitledGame
//
//  Created by Linar Zinatullin on 07/12/23.
//

import Foundation
import SpriteKit

extension GameScene {
    
    private func setUpGame() {
        //needs gameLogic reference in GameScene
        self.gameLogic.setUpGame()
        self.backgroundColor = SKColor.darkGray
        //there is no player to create yet!
//        let playerInitialPosition = CGPoint(x: self.frame.width/2, y: self.frame.height/6)
//        self.createPlayer(at: playerInitialPosition)
    }
    
    private func setUpPhysicsWorld() {
        // TODO: Customize!
        physicsWorld.contactDelegate = self
    }
    
    
    private func createPlayer(at position: CGPoint) {
        self.player = SKSpriteNode(imageNamed: "")
        self.player.name = "player"
        self.player.position = position
        player.physicsBody = SKPhysicsBody(circleOfRadius: 25.0)
        addChild(self.player)
    }
    
}
