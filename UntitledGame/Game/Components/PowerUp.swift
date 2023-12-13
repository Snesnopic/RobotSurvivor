//
//  PowerUp.swift
//  UntitledGame
//
//  Created by Giuseppe Casillo on 13/12/23.
//

import Foundation
import SpriteKit

extension GameScene{
    func increaseHealth(){
        let newMaxHp = player.userData!["maxHp"] as! Double * 1.1
        player.userData!["maxHp"] = newMaxHp
    }
    
    func increasePlayerSpeed(){
        let newSpeed = player.userData!["speed"] as! Int + 5
        player.userData!["speed"] = newSpeed
    }
    
    func increaseFireRate(){
        fireRate = fireRate - 0.5
    }
    
    func increaseBulletSpeed(){
        spd = spd - 1
    }
    
    func increaseDamage(){
        dmg = dmg + 5
    }
    
}
