//
//  EnemyType.swift
//  UntitledGame
//
//  Created by Linar Zinatullin on 11/12/23.
//

import Foundation

struct EnemyType {
    let name: String
    let health: Int
    let speed: Double
    let points: Int
    let damage: Double
}

struct EnemyBossType{
    let name: String
    let health: Int
    let speed: Double
    let points: Int
    let parts: EnemyType
}
