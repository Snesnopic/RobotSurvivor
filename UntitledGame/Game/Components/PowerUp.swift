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
        let newMaxHp = player.userData!["maxhp"] as! Double * 1.1
        player.userData!["maxhp"] = newMaxHp
    }
    
    func increasePlayerSpeed(){
        let newSpeed = player.userData!["speed"] as! Int + 5
        player.userData!["speed"] = newSpeed
    }
    
    func increaseFireRate(){
        //debug purpose:
        fireRate = 1000000
//        fireRate += 3
    }
    
    func increaseBulletSpeed(){
        spd += 2
    }
    
    func increaseDamage(){
        dmg += 8
    }
    
    func callPowerUp(name: String){
        switch name {
        case "+dmg":
            increaseDamage()
            break
        case "+hp":
            increaseHealth()
            break
        case "+firerate":
            increaseFireRate()
            break
        case "+bullet speed":
            increaseBulletSpeed()
            break
        case "+speed":
            increasePlayerSpeed()
            break
        default:
            break
        }
    }
}
