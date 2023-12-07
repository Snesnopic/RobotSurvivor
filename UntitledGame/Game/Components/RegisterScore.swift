//
//  RegisterScore.swift
//  UntitledGame
//
//  Created by Linar Zinatullin on 07/12/23.
//

import Foundation
import SpriteKit

extension GameScene{
    private func increaseScore(value: Int){
        gameLogic.increaseScore(points: value)
    }
}
