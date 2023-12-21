//
//  EnemyBehavior.swift
//  UntitledGame
//
//  Created by Linar Zinatullin on 07/12/23.
//

import Foundation
import SpriteKit


extension GameScene {
    
    func enemyLogic(){
        var activeEnemiesCount = enemiesOnMap.count
        while activeEnemiesCount < 1+spawnRate {
            //there must always be 40 enemies in the map
            createEnemy(powerFactor: multiplier)
            activeEnemiesCount += 1
        }
        
        
        //        let activeBosses = children.compactMap { $0 as? EnemyBossNode }
        //
        //        if activeBosses.isEmpty {
        //            if isBossReady {
        //                isBossReady = false
        //                self.createBoss()
        //            }
        //        } else {
        //            activeBosses.forEach { activeBoss in
        //                activeBoss.configureMovement(player)
        //            }
        //            let activeParts = children.compactMap { $0 as? EnemyBodyBossNode }
        //            activeParts.forEach { activePart in
        //                activePart.configureMovement()
        //            }
        //        }
        
        
        
    }
    
    func getPositionNearPlayer() -> CGPoint {
        let offSet = Int.random(in: 10...100)
        let halfScreenWidth = Int(self.size.width / 2) + offSet
        let halfScreenHeight = Int(self.size.height / 2) + offSet
        let possibleSign = [-1,1]
        let sign = possibleSign.randomElement()
        
        let side = Int.random(in: 0..<4)
        var position = player.position
        if side < 2 {
            //spawns vertically
            position.y = position.y + CGFloat(halfScreenHeight * sign!)
            let upperX = Int(position.x) + halfScreenWidth
            let lowerX = Int(position.x) - halfScreenWidth
            position.x = CGFloat(Int.random(in: min(upperX, lowerX)...max(upperX,lowerX)))
        }
        else {
            //spawns horizontally
            position.x = position.x + CGFloat(halfScreenWidth * sign!)
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
        enemiesOnMap.insert(enemy)
        addChild(enemy)
    }
    
    
    func getRelocatePosition(enemy: EnemyNode) -> CGPoint{
        let offSet = Int.random(in: 10...30)
        let possibleSign = [-1,1]
        let sign = possibleSign.randomElement()
        
        var newPosition: CGPoint = CGPoint(x: 0, y: 0)
        let distance: CGPoint = CGPoint(x: player.position.x - enemy.position.x, y: player.position.y - enemy.position.y)
        newPosition.x = player.position.x + distance.x + CGFloat((offSet * sign!))
        newPosition.y = player.position.y + distance.y + CGFloat((offSet * sign!))
        
        return newPosition
    }
    
    func relocateEnemy(enemy: EnemyNode){
        let relocatedEnemy = EnemyNode(type: enemy.type, startPosition: getRelocatePosition(enemy: enemy))
        
        enemy.physicsBody?.affectedByGravity = false
        relocatedEnemy.userData!["health"] = enemy.userData!["health"] as! Double
        relocatedEnemy.userData!["speed"] = enemy.userData!["speed"] as! Double
        relocatedEnemy.userData!["points"] = enemy.userData!["points"] as! Double
        relocatedEnemy.userData!["damage"] = enemy.userData!["damage"] as! Double
        
        relocatedEnemy.zPosition = 2
        
        enemiesOnMap.remove(enemy)
        enemiesOnMap.insert(relocatedEnemy)
        enemy.removeFromParent()
        addChild(relocatedEnemy)
    }
    
    func createBoss() {
        let enemyBoss = EnemyBossNode(type: EnemyTypesVM.enemyBoss , startPosition: getPositionNearPlayer())
        enemyBoss.physicsBody?.affectedByGravity = false
        enemyBoss.zPosition = 2
        addChild(enemyBoss)
        
        var nodeToFollow: SKSpriteNode = enemyBoss.self
        for _ in 0..<4 {
            let enemyPart = EnemyBodyBossNode(type: enemyBoss.type.parts, startPosition: CGPoint(x: enemyBoss.position.x + 10, y: enemyBoss.position.y + 10), nodeToFollow: nodeToFollow)
            enemyPart.zPosition = 1
            addChild(enemyPart)
            nodeToFollow = enemyPart.self
        }
    }
}
