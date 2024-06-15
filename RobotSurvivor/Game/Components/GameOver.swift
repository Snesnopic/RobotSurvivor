//
//  GameOver.swift
//  UntitledGame
//
//  Created by Giuseppe Casillo on 07/12/23.
//

import Foundation
import GameKit

extension GameScene {

    var isGameOver: Bool {
        return gameLogic.isGameOver
    }

    func finishGame() {
        GKLeaderboard.submitScore(gameLogic.currentScore, context: 0, player: GKLocalPlayer.local, leaderboardIDs: ["highscores"]) { error in
            if error != nil {
                print("Error: \(error!)")
            }
        }
        gameLogic.isGameOver = true
        self.scene?.isPaused = true
        player.hp = 0
    }

}
