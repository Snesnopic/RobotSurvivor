//
//  PickUps.swift
//  UntitledGame
//
//  Created by Giuseppe Casillo on 16/12/23.
//

import Foundation
import SpriteKit

extension GameScene {

    // MARK: It's better to leave the logic like this: spawnNamePickUp and later define the action (i.e. magnet()) so that more pickups could be added in the future. Add different pickup such as FOOD, MAGNET, TEMPORARY INVINCIBILITY ETC.ETC. and also different sprites

    func spawnMagnetPickUp() {

        readyToSpawnPickUp = false
        let newPickUp = SKSpriteNode(imageNamed: "magnet")
        newPickUp.texture?.filteringMode = .nearest
        newPickUp.size = CGSize(width: 20, height: 20)
        newPickUp.name = "pickUp"
        newPickUp.position = getPositionNearPlayer()
        newPickUp.zPosition = 0

        newPickUp.physicsBody = SKPhysicsBody(circleOfRadius: 7)
        newPickUp.physicsBody?.affectedByGravity = false

        // don't insert collisionBitMask for enemies
        newPickUp.physicsBody?.categoryBitMask = CollisionType.pickUp
        newPickUp.physicsBody?.collisionBitMask = CollisionType.player

        addChild(newPickUp)

        let waitAction = SKAction.wait(forDuration: 45)
        let enableSpawnMagnetPickUpAction = SKAction.run {
            self.readyToSpawnPickUp = true
        }
        let sequence = SKAction.sequence([waitAction, enableSpawnMagnetPickUpAction])
        run(sequence, withKey: "increaseSpawnMagnetPickUp")
    }

    // MARK: It's better to leave the logic like this
    func magnet() {
        xpToMagnetise = xpOnMap
    }
}
