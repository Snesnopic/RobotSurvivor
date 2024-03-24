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
        let newMaxHp = Int(Double(player.maxHp) * 1.2)
        let difference = player.maxHp - newMaxHp
        player.hp +=  difference
        player.maxHp = newMaxHp
        
        updateHpBar()
    }
    
    func increasePlayerSpeed(){
        player.movementSpeed += 10
    }
    
    func increaseFireRate(){
        //debug purpose:
//        fireRate += 100
        fireRate += 0.33
    }
    
    func increaseBulletSpeed(){
        spd += 2
    }
    
    func increaseDamage(){
        dmg += 10
    }
    
    func callPowerUp(name: String){
        switch name {
        case "dmg":
            increaseDamage()
            break
        case "hp":
            increaseHealth()
            break
        case "firerate":
            increaseFireRate()
            break
        case "bullet speed":
            increaseBulletSpeed()
            break
        case "speed":
            increasePlayerSpeed()
            break
        default:
            break
        }
    }
}
