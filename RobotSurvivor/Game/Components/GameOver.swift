//
//  GameOver.swift
//  UntitledGame
//
//  Created by Giuseppe Casillo on 07/12/23.
//

import Foundation

extension GameScene{
    
    var isGameOver: Bool {
        return gameLogic.isGameOver
    }
    
    func finishGame() {
        gameLogic.isGameOver = true
        self.scene?.isPaused = true
        player.userData!["hp"] = 0
    }
    
}
