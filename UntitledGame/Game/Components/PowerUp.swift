//
//  PowerUp.swift
//  UntitledGame
//
//  Created by Giuseppe Casillo on 13/12/23.
//

import Foundation
import SpriteKit

extension GameScene{
    public func increaseHealth(){
        let newMaxHp = player.userData!["maxHp"] as! Double * 1.1
        player.userData!["maxHp"] = newMaxHp
    }
    
    public func increaseSpeed(){
        let newSpeed = player.userData!["speed"] as! Int + 5
        player.userData!["speed"] = newSpeed
    }
    
}
