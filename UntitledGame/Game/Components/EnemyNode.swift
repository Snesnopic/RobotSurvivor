//
//  EnemyNode.swift
//  UntitledGame
//
//  Created by Linar Zinatullin on 11/12/23.
//

import Foundation
import SpriteKit

class EnemyNode: SKSpriteNode {
    var type: EnemyType
    var health: Int
    
    init(type: EnemyType,  startPosition: CGPoint, offset: CGFloat) {
       
        self.type = type
        self.health = type.health
        let texture = SKTexture(imageNamed: "WaspEnemy_0")
        super.init(texture: texture,color: .white, size: texture.size())
        
        name = "enemy"
        physicsBody = SKPhysicsBody(rectangleOf: texture.size())
        position = CGPoint (x: startPosition.x + offset,  y: startPosition.y + offset)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("LOL NO")
    }
    
    
    func configureMovement(_ player: SKSpriteNode){
        let path = UIBezierPath()
        path.move(to: .zero)
        
        path.addLine(to: CGPoint(x: player.position.x - self.position.x, y: player.position.y - self.position.y))
        
        
        let movement = SKAction.follow(path.cgPath,asOffset: true, orientToPath: true, speed: type.speed)
        let sequence = SKAction.sequence([movement])
        run(sequence)
    }
}

