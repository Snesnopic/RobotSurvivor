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
        
        let firstBody: SKPhysicsBody = contact.bodyA
        let secondBody: SKPhysicsBody = contact.bodyB
        print("d")

        if let node = firstBody.node as? EnemyNode, let bool = node.name?.hasPrefix("enemy"){
            stopEnemyMovement(node)
            
        }
        if let node = secondBody.node as? EnemyNode, let bool = node.name?.hasPrefix("enemy"){
            
            stopEnemyMovement(node)
            
        }
    }
    
    func stopEnemyMovement(_ enemy: EnemyNode) {
        enemy.removeAllActions()  // This stops the follow path action
        enemy.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        print("stop Move")
    }
}
