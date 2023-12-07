//
//  GameOver.swift
//  UntitledGame
//
//  Created by Giuseppe Casillo on 07/12/23.
//

import Foundation

extension GameScene{
    
    var isGameOver: Bool {
        
        /*if (player.life <= 0){
         isGameOver = true
         }
         */
        return gameLogic.isGameOver
    }
    
    private func finishGame() {
        gameLogic.isGameOver = true
    }
    
}
