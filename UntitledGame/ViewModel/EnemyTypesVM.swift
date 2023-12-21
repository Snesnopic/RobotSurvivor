//
//  EnemyTypesVM.swift
//  UntitledGame
//
//  Created by Linar Zinatullin on 11/12/23.
//

import Foundation

class EnemyTypesVM {
    var enemyTypes: [EnemyType] = [
        EnemyType(name: "Wasp", health: 8, speed: 50, points: 10, damage: 2),
        EnemyType(name: "Scarab", health: 15, speed: 35, points: 20, damage: 5),
        EnemyType(name: "Spider", health: 20, speed: 40, points: 25, damage: 7),
        EnemyType(name: "Hornet", health: 7, speed: 55, points: 20, damage: 3)
    ]
    static var enemyBoss: EnemyBossType =
    EnemyBossType(name: "Centipede", health: 100, speed: 70, points: 150, parts: EnemyType(name: "CentipedeBody", health: 20, speed: 70, points: 30, damage: 30))
    
    
}
