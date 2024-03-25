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
        var tileImageName: String
        let tileType = Int.random(in: 1...100)
        
        tileImageName = (tileType <= 70) ? "Moon1" : ((tileType > 70 && tileType < 90) ? "Moon2" : "Moon3")        
        
        let tile = SKSpriteNode(imageNamed: tileImageName)
        tile.name = "tile"
        tile.position = position
        tile.zPosition = -1
        tile.texture?.filteringMode = .nearest
        
        tilePositions.insert(position)
        addChild(tile)
        
    }
    func newCenterTile() {
        let baseX = Int(player.position.x / tileSize.width)
        let baseY = Int(player.position.y / tileSize.height)
        
        centerTile.x = CGFloat(baseX * Int(tileSize.width))
        centerTile.y = CGFloat(baseY * Int(tileSize.height))
    }
    func updateTiles() {
        newCenterTile()
        // Load new tiles
        for x in stride(from: centerTile.x - 1536, through: centerTile.x + 1536, by: tileSize.width) {
            for y in stride(from: centerTile.y - 1536, through: centerTile.y + 1536, by: tileSize.height) {
                let position = CGPoint(x: x, y: y)
                if !isTilePresent(at: position) {
                    addTile(at: position)
                }
            }
        }
        for node in self.children.compactMap({ $0 as? SKSpriteNode }) {
            if(node.name == "tile"){
                if(node.position.x < centerTile.x - 1536 || node.position.x > centerTile.x + 1536)
                    {
                    tilePositions.remove(node.position)
                    node.removeFromParent()
                }else if(node.position.y < centerTile.y - 1536 || node.position.y > centerTile.y + 1536){
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
