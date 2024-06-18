//
//  EnemyBehavior.swift
//  UntitledGame
//
//  Created by Linar Zinatullin on 07/12/23.
//

import Foundation
import SpriteKit

extension GameScene {

    func enemyLogic() {
        var activeEnemiesCount = enemiesOnMap.count
        while activeEnemiesCount < 1+spawnRate {
            // there must always be 40 enemies in the map
            createEnemy(powerFactor: multiplier)
            activeEnemiesCount += 1
        }
        if Int(gameLogic.time + 1) % 120 == 0 && !isBossActive {
            print("I should spawn the boss!")
            isBossActive = true
            createBoss(powerFactor: multiplier)
        }
    }
    func bossLogic() {
        activeBoss?.configureMovement(player)
        activeBoss?.bodyParts.forEach({ bodyPart in
            bodyPart.configureMovement(bodyPart.nodeToFollow)
        })
    }
    func getPositionNearPlayer() -> CGPoint {
        let offSet = Int.random(in: 10...100)
        let halfScreenWidth = Int(self.size.width / 2) + offSet
        let halfScreenHeight = Int(self.size.height / 2) + offSet
        let possibleSign = [-1, 1]
        let sign = possibleSign.randomElement()

        let side = Int.random(in: 0..<4)
        var position = player.position
        if side < 2 {
            // spawns vertically
            position.y += CGFloat(halfScreenHeight * sign!)
            let upperX = Int(position.x) + halfScreenWidth
            let lowerX = Int(position.x) - halfScreenWidth
            position.x = CGFloat(Int.random(in: min(upperX, lowerX)...max(upperX, lowerX)))
        } else {
            // spawns horizontally
            position.x += CGFloat(halfScreenWidth * sign!)
            let upperY = Int(position.y) + halfScreenHeight
            let lowerY = Int(position.y) - halfScreenHeight
            position.y = CGFloat(Int.random(in: min(upperY, lowerY)...max(upperY, lowerY)))
        }
        return position
    }

    func createEnemy(powerFactor: Double) {
        let enemyType = Int.random(in: 0..<enemyTypes.count - 2)
        let enemy = EnemyNode(type: enemyTypes[enemyType], startPosition: getPositionNearPlayer())
        enemy.physicsBody?.affectedByGravity = false
        enemy.health = Int(Double(enemy.health) * powerFactor)
        enemy.movementSpeed += (powerFactor * 8)
        enemy.points = Int(Double(enemy.points) * powerFactor)
        enemy.damage *= powerFactor

        enemy.zPosition = 2
        enemiesOnMap.insert(enemy)
        addChild(enemy)
    }

    func getRelocatePosition(enemy: EnemyNode) -> CGPoint {
        let offSet = Int.random(in: 10...30)
        let possibleSign = [-1, 1]
        let sign = possibleSign.randomElement()

        var newPosition: CGPoint = CGPoint(x: 0, y: 0)
        let distance: CGPoint = CGPoint(x: player.position.x - enemy.position.x, y: player.position.y - enemy.position.y)
        newPosition.x = player.position.x + distance.x + CGFloat((offSet * sign!))
        newPosition.y = player.position.y + distance.y + CGFloat((offSet * sign!))

        return newPosition
    }

    // everytime the player outruns the enemies, and reach the "out of bounds" they get relocated
    func relocateEnemy() {

        readyToRecolate = false
        for enemy in enemiesOnMap where distanceBetween(node1: enemy, node2: player) > Float((frame.height + frame.width)/2.8) {

            let relocatedEnemy = EnemyNode(type: enemy.type, startPosition: getRelocatePosition(enemy: enemy))

            enemy.physicsBody?.affectedByGravity = false
            relocatedEnemy.health = enemy.health
            relocatedEnemy.movementSpeed = enemy.movementSpeed
            relocatedEnemy.points = enemy.points
            relocatedEnemy.damage = enemy.damage

            relocatedEnemy.zPosition = 2

            enemiesOnMap.remove(enemy)
            enemiesOnMap.insert(relocatedEnemy)
            enemy.removeFromParent()
            addChild(relocatedEnemy)

        }

        let waitAction = SKAction.wait(forDuration: 3)
        let enableReload = SKAction.run {
            self.readyToRecolate = true
        }

        let sequence = SKAction.sequence([waitAction, enableReload])
        run(sequence)
    }

    // icnrease difficulty of the game by spawning more enemies
    func increaseSpawnRate() {
        readyToIncreaseSpawnRate = false
        self.spawnRate += 4

        let waitAction = SKAction.wait(forDuration: 25)
        let enableSpawnRateIncreaseAction = SKAction.run {
            self.readyToIncreaseSpawnRate = true
        }

        let sequence = SKAction.sequence([waitAction, enableSpawnRateIncreaseAction])
        run(sequence, withKey: "increaseSpawnRateAction")
    }

    // same as above
    func increaseEnemyPower() {
        readyToIncreaseEnemyPower = false
        multiplier += 1

        let waitAction = SKAction.wait(forDuration: 55)
        let enableIncreaseEnemyPowerAction = SKAction.run {
            self.readyToIncreaseEnemyPower = true
        }
        let sequence = SKAction.sequence([waitAction, enableIncreaseEnemyPowerAction])
        run(sequence, withKey: "increaseEnemyRatePower")
    }

    func createBoss(powerFactor: Double) {

        let bossEnemyType = EnemyTypesVM.enemyTypes.first(where: { enemy in
            return enemy.name == "CentipedeHead"
        })!
        let enemyBoss = EnemyBossNode(type: bossEnemyType, startPosition: getPositionNearPlayer(), parts: Int(powerFactor + 2))

        enemyBoss.physicsBody?.affectedByGravity = false
        enemyBoss.health = Int(Double(enemyBoss.health) * (powerFactor * powerFactor * powerFactor))
        enemyBoss.movementSpeed += (powerFactor * powerFactor)
        enemyBoss.points = Int(Double(enemyBoss.points) * powerFactor * powerFactor)
        enemyBoss.damage *= (powerFactor * 0.3)
        enemyBoss.bodyParts.forEach { enemyBodyBossNode in
            enemyBodyBossNode.health = Int(Double(enemyBoss.health) * (powerFactor * powerFactor))
            enemyBodyBossNode.movementSpeed = enemyBoss.movementSpeed + (powerFactor * powerFactor) + powerFactor
            enemyBodyBossNode.points = Int(Double(enemyBoss.points) * powerFactor * powerFactor)
            enemyBodyBossNode.damage = enemyBoss.damage * (powerFactor * 0.1)
        }
        activeBoss = enemyBoss
        enemyBoss.zPosition = 2
        addChild(enemyBoss)
        enemyBoss.bodyParts.forEach { bodyPart in
            addChild(bodyPart)
        }
    }
}
