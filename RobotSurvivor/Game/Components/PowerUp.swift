//
//  PowerUp.swift
//  UntitledGame
//
//  Created by Giuseppe Casillo on 13/12/23.
//

import Foundation
import SpriteKit

extension GameScene {

    func increaseHealth( ) {
        let newMaxHp = Int(Double(player.maxHp) * 1.2)
        let difference = newMaxHp - player.maxHp
        player.hp += difference
        player.maxHp = newMaxHp
        updateHpBar()
    }

    func increasePlayerSpeed( ) {
        player.movementSpeed += 10
    }

    func increaseFireRate( ) {
        fireRate += 0.85
    }

    func increaseBulletSpeed( ) {
        spd += 2
    }

    func increaseDamage( ) {
        dmg += 10
    }

    func callPowerUp(name: String.LocalizationValue ) {
        switch name {
        case "+dmg":
            increaseDamage()
        case "+hp":
            increaseHealth()
        case "+firerate":
            increaseFireRate()
        case "+bullet speed":
            increaseBulletSpeed()
        case "+speed":
            increasePlayerSpeed()
        default:
            break
        }
    }
}
