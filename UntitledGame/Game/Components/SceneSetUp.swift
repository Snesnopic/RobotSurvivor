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
        //needs gameLogic reference in GameScene
        self.gameLogic.setUpGame()
       
        self.backgroundColor = SKColor.darkGray
        //there is no player to create yet!
        let playerInitialPosition = CGPoint(x: self.frame.width/2, y: self.frame.height/2)
        self.createPlayer(at: playerInitialPosition)
        self.joystick = Joystick(player: player)
        self.joystick.name = "joystick"
        self.joystick.position = CGPoint(x: 10, y: 10)
        addChild(joystick)
    }
    
    private func setUpPhysicsWorld() {
        // TODO: Customize!
        physicsWorld.contactDelegate = self
    }
    
    
    private func createPlayer(at position: CGPoint) {
        self.player = SKSpriteNode(imageNamed: "stick")
        self.player.name = "player"
        self.player.position = position
        player.physicsBody = SKPhysicsBody(circleOfRadius: 25.0)
        self.player.physicsBody?.affectedByGravity = false
        addChild(self.player)
    }
    
}
