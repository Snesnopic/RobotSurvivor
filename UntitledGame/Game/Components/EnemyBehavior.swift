//
//  EnemyBehavior.swift
//  UntitledGame
//
//  Created by Linar Zinatullin on 07/12/23.
//

import Foundation
import SpriteKit


extension GameScene {
    
    func enemyLogic(currentTime: TimeInterval){
        let activeEnemies = children.compactMap{$0 as? EnemyNode}
        
        if activeEnemies.isEmpty {
            createEnemies()
            
        }
        
        for activeEnemy in activeEnemies {
            activeEnemy.configureMovement(player)
            activeEnemy.zRotation = 0
        }
    }
    
    func createEnemies() {
        let enemyOffset: CGFloat = 100
        let enemyStartX: CGFloat = 200
        let enemyStartY = player.position.y + 100
        
        let enemyType = Int.random(in: 0..<3)
        
        for (index, position) in positions.shuffled().enumerated(){
            let enemy = EnemyNode(type: enemyTypes[enemyType], startPosition: CGPoint(x: enemyStartX, y: CGFloat(position)), offset: enemyOffset * CGFloat(index * 3))
            enemy.physicsBody?.affectedByGravity = false
            addChild(enemy)
            
        }
    }
}
