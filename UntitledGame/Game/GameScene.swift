//
//  GameScene.swift
//  UntitledGame
//
//  Created by Giuseppe Francione on 06/12/23.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    // Keeps track of when the last update happend.
    // Used to calculate how much time has passed between updates.
    var lastUpdate: TimeInterval = 0
    
    override func didMove(to view: SKView) {
        print("You are in the game scene!")
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        
    }
}
