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
        let difference = player.userData!["maxhp"] as! Double - newMaxHp
        let currentHp = player.userData!["hp"] as! Double
        player.userData!["hp"] = currentHp + difference
        player.userData!["maxhp"] = newMaxHp
        
        updateHpBar()
    }
    
    func increasePlayerSpeed(){
        let newSpeed = player.userData!["speed"] as! Int + 5
        player.userData!["speed"] = newSpeed
    }
    
    func increaseFireRate(){
        //debug purpose:
//        fireRate = 30
        fireRate += 0.25
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
