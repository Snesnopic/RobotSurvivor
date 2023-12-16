//
//  EnemyTypesVM.swift
//  UntitledGame
//
//  Created by Linar Zinatullin on 11/12/23.
//

import Foundation

class EnemyTypesVM {
    var enemyTypes: [EnemyType] = [
        EnemyType(name: "Wasp", health: 10, speed: 50, points: 30),
        EnemyType(name: "Scarab", health: 12, speed: 35, points: 20),
        EnemyType(name: "Spider", health: 8, speed: 40, points: 15),
        EnemyType(name: "Hornet", health: 10, speed: 45, points: 30)
    ]
    static var enemyBoss: EnemyBossType =
    EnemyBossType(name: "Centipede", health: 100, speed: 70, points: 150, parts: EnemyType(name: "CentipedeBody", health: 20, speed: 70, points: 30))
    
    
}
