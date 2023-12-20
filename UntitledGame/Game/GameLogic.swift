//
//  GameLogic.swift
//  UntitledGame
//
//  Created by Linar Zinatullin on 07/12/23.
//

import Foundation

@Observable
class GameLogic {
    
    static func restart() -> GameLogic {
        var gameLogic: GameLogic = .init()
        GameLogic.shared = gameLogic
        return GameLogic.shared
    }
    
    func restart() -> GameLogic {
        return GameLogic.restart()
    }
    
    static private(set) var shared: GameLogic = .init()
    
    private init() {}
    
    //general
    var time: TimeInterval = 0 {
        willSet {
            print("something - \(String(describing: newValue))")
        }
    }
    var currentScore: Int = 0 {
        willSet {
            print("something - \(String(describing: newValue))")
        }
    }
    var isGameOver = false {
        willSet {
            print("something - \(String(describing: newValue))")
        }
    }
    var joystick: Joystick? {
        willSet {
            print("something - \(String(describing: newValue))")
        }
    }
    //xp system
    var currentXP: Int = 0 {
        willSet {
            print("something - \(String(describing: newValue))")
        }
    }
    var xpToNextLvl: Int = 30 {
        willSet {
            print("something - \(String(describing: newValue))")
        }
    }
    var showPowerUp: Bool = false {
        willSet {
            print("something - \(String(describing: newValue))")
        }
    }
    //settings
    var musicVolume: Int = 5 {
        willSet {
            print("something - \(String(describing: newValue))")
        }
    }
    var soundsVolume: Int = 5 {
        willSet {
            print("something - \(String(describing: newValue))")
        }
    }
    var musicSwitch: Bool = true {
        willSet {
            print("something - \(String(describing: newValue))")
        }
    }
    var soundsSwitch: Bool = true {
        willSet {
            print("something - \(String(describing: newValue))")
        }
    }
    var showPauseMenu: Bool = false {
        willSet {
            print("something - \(String(describing: newValue))")
        }
    }
    
    func increaseScore(points: Int){
        self.currentScore += points
    }
    
    func increaseTime(by t: TimeInterval){
        self.time += t
    }
    
    func finishGame(){
        if self.isGameOver == false{
            self.isGameOver = true
        }
    }
    
}
