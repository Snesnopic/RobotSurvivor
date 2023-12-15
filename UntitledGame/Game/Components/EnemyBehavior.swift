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
        while activeEnemiesCount < 1+spawnRate {
            //there must always be 40 enemies in the map
            createEnemy(powerFactor: multiplier)
            activeEnemiesCount += 1
        }
        
        let farAwayEnemies: [EnemyNode] = activeEnemies.filter { node in
            return distanceBetween(node1: node, node2: player) > (Float(self.frame.height + self.frame.width))
        }
        
        farAwayEnemies.forEach { node in
            node.position = getPositionNearPlayer()
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
    
    func getPositionNearPlayer() -> CGPoint {
        let offSet = Int.random(in: 10...100)
        let halfScreenWidth = Int(self.size.width / 2) + offSet
        let halfScreenHeight = Int(self.size.height / 2) + offSet
        
        let side = Int.random(in: 0..<4)
        var position = player.position
        if side < 2 {
            //spawns vertically
            position.y = position.y + CGFloat(halfScreenHeight * generateSign(number: side%2))
            let upperX = Int(position.x) + halfScreenWidth
            let lowerX = Int(position.x) - halfScreenWidth
            position.x = CGFloat(Int.random(in: min(upperX, lowerX)...max(upperX,lowerX)))
        }
        else {
            //spawns horizontally
            position.x = position.x + CGFloat(halfScreenWidth * generateSign(number: side%2))
            let upperY = Int(position.y) + halfScreenHeight
            let lowerY = Int(position.y) - halfScreenHeight
            position.y = CGFloat(Int.random(in: min(upperY, lowerY)...max(upperY,lowerY)))
        }
        return position
    }
    
    func createEnemy(powerFactor: Double) {
        let enemyType = Int.random(in: 0..<enemyTypes.count)
        let enemy = EnemyNode(type: enemyTypes[enemyType], startPosition: getPositionNearPlayer())
        enemy.physicsBody?.affectedByGravity = false
        enemy.userData!["health"] = enemy.userData!["health"] as! Double * powerFactor
        enemy.userData!["speed"] = enemy.userData!["speed"] as! Double + (powerFactor * 3)
        enemy.userData!["points"] = enemy.userData!["points"] as! Double * powerFactor
        enemy.userData!["damage"] = enemy.userData!["damage"] as! Double * powerFactor
        
        enemy.zPosition = 2
        addChild(enemy)
    }
}
