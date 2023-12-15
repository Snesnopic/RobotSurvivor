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
        
        if(fireRate == 1.7 || fireRate == 1.5){
            fireRate = fireRate - 0.2
        }else{
            fireRate = fireRate - 0.3
        }
    }
    
    func increaseBulletSpeed(){
        spd = spd + 1
    }
    
    func increaseDamage(){
        dmg = dmg + 5
    }
    
    func callPowerUp(name: String){
        if(name == "more_dmg"){
            increaseDamage()
        }else if(name == "more_hp"){
            increaseHealth()
        }else if(name == "more_firerate"){
            increaseFireRate()
        }else if(name == "more_bullet_speed"){
            increaseBulletSpeed()
        }else if(name == "more_speed"){
            increasePlayerSpeed()
        }
    }
    
}
