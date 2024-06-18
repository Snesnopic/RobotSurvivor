//
//  PlayerSetUp.swift
//  Robot Survivor
//
//  Created by Giuseppe Casillo on 21/12/23.
//

import Foundation
import SpriteKit

extension GameScene {
    func createPlayer(at position: CGPoint) {

        let healthBarFill = SKShapeNode(rect: CGRect(origin: .zero, size: CGSize(width: player.size.width, height: 5.0)))
        let healthBarTotal = SKShapeNode(rect: CGRect(origin: .zero, size: CGSize(width: player.size.width, height: 5.0)))

        healthBarTotal.fillColor = UIColor(red: 0.54, green: 0.0, blue: 0.0, alpha: 1.0)
        healthBarFill.fillColor = UIColor.red

        healthBarTotal.strokeColor = UIColor(red: 0.54, green: 0.0, blue: 0.0, alpha: 1.0)
        healthBarFill.strokeColor = UIColor.red

        healthBarTotal.zPosition = 2
        healthBarFill.zPosition = healthBarTotal.zPosition + 1

        healthBar.addChild(healthBarTotal)
        healthBar.addChild(healthBarFill)

        healthBar.children.forEach { node in
            node.position = player.position
            node.position.x -= (player.size.width / 2)
            node.position.y -= player.size.height
        }

        addChild(healthBar)
        addChild(self.player)
    }

}
