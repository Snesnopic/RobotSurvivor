//
//  GameLogic.swift
//  UntitledGame
//
//  Created by Linar Zinatullin on 07/12/23.
//

import Foundation
import SwiftUI

class GameLogic: ObservableObject {
    
    static let shared: GameLogic = GameLogic()
    
    func restartGame(){
        self.currentScore = 0
        self.currentXP = 0
        self.xpToNextLvl = 30
        self.time = 0
        self.playerLevel = 1
        self.isGameOver = false
    }
    @AppStorage ("showTutorial") var showTutorial: Bool = true
    //general
    @Published var time: TimeInterval = 0
    @Published var currentScore: Int = 0
    @Published var isGameOver = false
    @Published var joystick: Joystick?
    @Published var currentSkin: String = "AntiTank"
    //xp system
    @Published var currentXP: Int = 0
    @Published var xpToNextLvl: Int = 30
    @Published var showPowerUp: Bool = false
    @Published var playerLevel = 1
    //settings
    @AppStorage ("musicVolume") var musicVolume: Int = 5
    @AppStorage ("soundsVolume") var soundsVolume: Int = 5
    @AppStorage ("musicSwitch") var musicSwitch: Bool = true
    @AppStorage ("soundsSwitch") var soundsSwitch: Bool = true
    @Published var showPauseMenu: Bool = false
    
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
    
    
}
