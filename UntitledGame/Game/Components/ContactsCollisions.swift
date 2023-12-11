//
//  ContactsCollisions.swift
//  UntitledGame
//
//  Created by Linar Zinatullin on 11/12/23.
//

import Foundation
import SpriteKit

extension GameScene{
    
    func didBegin(_ contact: SKPhysicsContact) {
        // Determine if the contact is between an enemy and the player
        if let enemy = contact.bodyA.node as? EnemyNode, contact.bodyB.node == player {
            stopEnemyMovement(enemy)
        } else if let enemy = contact.bodyB.node as? EnemyNode, contact.bodyA.node == player {
            stopEnemyMovement(enemy)
        }
    }
    
    func stopEnemyMovement(_ enemy: EnemyNode) {
        enemy.removeAllActions()  // This stops the follow path action
        enemy.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
    }
}
