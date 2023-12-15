//
//  EnemyTypesVM.swift
//  UntitledGame
//
//  Created by Linar Zinatullin on 11/12/23.
//

import Foundation

class EnemyTypesVM {
    var enemyTypes: [EnemyType] = [
        EnemyType(name: "Wasp", health: 15, speed: 65, points: 30, damage: 3),
        EnemyType(name: "Scarab", health: 20, speed: 35, points: 20, damage: 7),
        EnemyType(name: "Spider", health: 8, speed: 40, points: 15, damage: 5),
        EnemyType(name: "Hornet", health: 10, speed: 70, points: 30, damage: 2)
    ]
}
