//
//  EnemyTypesVM.swift
//  UntitledGame
//
//  Created by Linar Zinatullin on 11/12/23.
//

import Foundation

class EnemyTypesVM {
    static var enemyTypes: [EnemyType] = [
        EnemyType(name: "Wasp", health: 3, speed: 50, points: 10, damage: 2),
        EnemyType(name: "Scarab", health: 6, speed: 35, points: 20, damage: 5),
        EnemyType(name: "Spider", health: 10, speed: 40, points: 25, damage: 7),
        EnemyType(name: "Hornet", health: 4, speed: 55, points: 20, damage: 3),
        EnemyType(name: "CentipedeHead", health: 100, speed: 65, points: 100, damage: 12),
        EnemyType(name: "CentipedeBody", health: 11, speed: 65, points: 12, damage: 2)
    ]
}
