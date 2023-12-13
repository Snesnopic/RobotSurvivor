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
        let activeEnemies: [EnemyNode] = children.filter { node in
            return node.isKind(of: EnemyNode.classForCoder())
        } as! [EnemyNode]
        var activeEnemiesCount = activeEnemies.count
        while activeEnemiesCount < 40 {
            //there must always be 40 enemies in the map
            createEnemy()
            activeEnemiesCount += 1
        }
        
        for activeEnemy in activeEnemies {
            activeEnemy.configureMovement(player)
        }
    }
    private func generateSign(number: Int) -> Int {
        if number % 2 == 0 {
            return -1
        }
        else {
            return 1
        }
    }
    func createEnemy() {
        let offSet = Int.random(in: 10...50)
        let halfScreenWidth = Int(self.size.width / 2) + offSet
        let halfScreenHeight = Int(self.size.height / 2) + offSet
        let enemyType = Int.random(in: 0..<enemyTypes.count)
        
        let side = Int.random(in: 0..<4)
        var position = player.position
        if side < 2 {
            //spawns vertically
            position.y = position.y + CGFloat(halfScreenHeight * generateSign(number: side%2))
            let newX = Int(position.x) + halfScreenWidth
            position.x = CGFloat(Int.random(in: min(-newX, newX)...max(-newX,newX)))
        }
        else {
            //spawns horizontally
            position.x = position.x + CGFloat(halfScreenWidth * generateSign(number: side%2))
            let newY = Int(position.y) + halfScreenHeight
            position.y = CGFloat(Int.random(in: min(-newY, newY)...max(-newY,newY)))
        }
        let enemy = EnemyNode(type: enemyTypes[enemyType], startPosition: position)
        enemy.physicsBody?.affectedByGravity = false
       
        enemy.zPosition = 1;
        addChild(enemy)
    }
}
