//
//  SkinPreviewScene.swift
//  Robot Survivor
//
//  Created by Giuseppe Francione on 09/02/24.
//

import Foundation
import SpriteKit

class SkinPreviewScene: SKScene {
    var skin: String = "AntiTank"
    var isActive: Bool = true
    init(skin: String,isActive: Bool){
        super.init(size: CGSize(width: 50, height: 50))
        self.skin = skin
        self.isActive = isActive
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        print("You are previewing \(skin)!")
        let player:SKSpriteNode = SKSpriteNode(imageNamed: "\(skin)/Idle/1")
        let playerIdleAtlas: SKTextureAtlas = SKTextureAtlas(named: "\(skin)/Idle")
        var playerIdleTextures: [SKTexture] = []
        var playerIdleAnimation:SKAction = SKAction()
        
        if isActive {
            playerIdleAtlas.textureNames.sorted().forEach { string in
                let texture = playerIdleAtlas.textureNamed(string)
                texture.filteringMode = .nearest
                playerIdleTextures.append(texture)
            }
            playerIdleAnimation = SKAction.animate(with: playerIdleTextures, timePerFrame: 0.3)
            
        }
        else {
            let textureName = playerIdleAtlas.textureNames.sorted().first!
            let texture = playerIdleAtlas.textureNamed(textureName)
            texture.filteringMode = .nearest
            playerIdleTextures.append(texture)
            playerIdleAnimation = SKAction.animate(with: playerIdleTextures, timePerFrame: 0.3)
        }
        player.run(SKAction.repeatForever(playerIdleAnimation))
        
        backgroundColor = .clear
        player.name = "player"
        
        player.size = CGSize(width: 30, height: 30)
        player.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 20, height:  20))
        player.zPosition = 3
        player.position = CGPoint(x: 25, y: 25)
        player.physicsBody?.isDynamic = false
        
        addChild(player)
    }
}
