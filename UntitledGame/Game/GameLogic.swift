//
//  GameLogic.swift
//  UntitledGame
//
//  Created by Linar Zinatullin on 07/12/23.
//

import Foundation

class GameLogic: ObservableObject {
    
    static let shared: GameLogic = GameLogic()
    
    func setUpGame(){
        self.currentScore = 0
        self.currentXP = 0
        self.xpToNextLvl = 30
        self.time = 0
        self.isGameOver = false
    }
    
    //general
    @Published var time: TimeInterval = 0
    @Published var currentScore: Int = 0
    @Published var isGameOver = false
    //xp system
    @Published var currentXP: Int = 0
    @Published var xpToNextLvl: Int = 30
    @Published var showPowerUp: Bool = false
    
    func increaseScore(points: Int){
        self.currentScore = self.currentScore + points
    }
    
    func increaseTime(by t: TimeInterval){
        self.time = self.time + t
    }
    
    func finishGame(){
        if self.isGameOver == false{
            self.isGameOver = true
        }
    }
    
    func restartGame() {
        
        // TODO: Customize!
        
        self.setUpGame()
    }
    
}
