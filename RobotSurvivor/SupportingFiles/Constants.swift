//
//  Constants.swift
//  UntitledGame
//
//  Created by Linar Zinatullin on 12/12/23.
//

import Foundation

enum GameState {
    case mainScreen
    case playing
    case gameOver
    case tutorial
    case chooseChar
}

let creators = [
    "Giuseppe Francione",
    "Giuseppe Casillo",
    "Claudio Pepe",
    "Maya Navarrete",
    "Linar Zinatullin",
    "Davide Castaldi"
]

let skins = [
    "AntiTank",
    "Assault",
    "Grenadier",
    "MachineGunner",
    "RadioOperator",
    "Sniper",
    "SquadLeader"
]

let localizedSkins = [
    String(localized: "AntiTank"),
    String(localized: "Assault"),
    String(localized: "Grenadier"),
    String(localized: "MachineGunner"),
    String(localized: "RadioOperator"),
    String(localized: "Sniper"),
    String(localized: "SquadLeader")
]
