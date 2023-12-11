//
//  EnemyBehavior.swift
//  UntitledGame
//
//  Created by Linar Zinatullin on 07/12/23.
//

import Foundation
import SpriteKit

class EnemyNode: SKSpriteNode {
    var type: EnemyType
    
    init(type: EnemyType) {
       
        self.type = type
        let texture = SKTexture(imageNamed: type.name)
        super.init(texture: texture,color: .white, size: texture.size())
        
        name = "enemy"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("LOL NO")
    }
}
