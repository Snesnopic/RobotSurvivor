//
//  Tilemap.swift
//  Robot Survivor
//
//  Created by Giuseppe Casillo on 21/12/23.
//

import Foundation
import SpriteKit

extension GameScene{
    
    func addTile(at position: CGPoint) {
        let tileImageName: String
        let tileType = Int.random(in: 1...100)
        if(tileType <= 70){
            tileImageName = "Moon1"
        }else{
            tileImageName = "Moon2"
        }
        
        let tile = SKSpriteNode(imageNamed: tileImageName)
        tile.name = "tile"
        tile.position = position
        tile.zPosition = -1
        tile.texture?.filteringMode = .nearest
        
        tilePositions.insert(position)
        addChild(tile)
        
    }
    
    func updateTiles() {
        let playerPosition = player.position
        let visibleXDistance = 700
        let visibleYDistance = 700
        
        let minX = playerPosition.x - CGFloat(visibleXDistance)
        let maxX = playerPosition.x + CGFloat(visibleXDistance)
        let minY = playerPosition.y - CGFloat(visibleYDistance)
        let maxY = playerPosition.y + CGFloat(visibleYDistance)
        
        
        // Load new tiles
        for x in stride(from: minX, through: maxX, by: tileSize.width) {
            for y in stride(from: minY, through: maxY, by: tileSize.height) {
                let position = CGPoint(x: x, y: y)
                if !isTilePresent(at: position) {
                    if((position.x >= minX && position.x < (minX + 400)) || (position.x > (maxX - 400) && position.x <= maxX)){
                        addTile(at: position)
                    }else if((position.y >= minY && position.y < (minY + 300)) || (position.y > (maxY - 300) && position.y <= maxY)){
                        addTile(at: position)
                    }
                }
            }
        }
        for node in self.children.compactMap({ $0 as? SKSpriteNode }) {
            if(node.name == "tile"){
                if(node.position.x < minX || node.position.x > maxX)
                    {
                    tilePositions.remove(node.position)
                    node.removeFromParent()
                }else if(node.position.y < minY || node.position.y > maxY){
                    tilePositions.remove(node.position)
                    node.removeFromParent()
                }
            }
        }
        
    }
    
    func isTilePresent(at position: CGPoint) -> Bool {
        return tilePositions.contains(position)
    }
    
}
