//
//  SceneSetUp.swift
//  UntitledGame
//
//  Created by Linar Zinatullin on 07/12/23.
//

import Foundation
import SpriteKit

extension GameScene {
    
    func setUpGame() {
        self.setUpPhysicsWorld()
        self.backgroundColor = SKColor.darkGray
        let playerInitialPosition = CGPoint(x: self.frame.width/2, y: self.frame.height/2)
        self.createPlayer(at: playerInitialPosition)
        self.camera = sceneCamera
    }
    
    func setUpAnimations() {
        explosionAtlas.textureNames.sorted().forEach { string in
            let texture = explosionAtlas.textureNamed(string)
            texture.filteringMode = .nearest
            explosionTextures.append(texture)
        }
        explosionAnimation = SKAction.animate(with: explosionTextures, timePerFrame: 0.07)

        
        deathAnimationAtlas.textureNames.sorted().forEach { string in
            let texture = deathAnimationAtlas.textureNamed(string)
            texture.filteringMode = .nearest
            deathAnimationTextures.append(texture)
        }
        deathAnimation = SKAction.animate(with: deathAnimationTextures, timePerFrame: 0.5)
        
        let playerIdleAtlas: SKTextureAtlas = SKTextureAtlas(named: "\(playerSkin)/Idle")
        playerIdleAtlas.textureNames.sorted().forEach { string in
            let texture = playerIdleAtlas.textureNamed(string)
            texture.filteringMode = .nearest
            playerIdleTextures.append(texture)
        }
        playerIdleAnimation = SKAction.animate(with: playerIdleTextures, timePerFrame: 0.3)
        
        let shootAnimationAtlas = SKTextureAtlas(named: "\(playerSkin)/Fire")
        shootAnimationAtlas.textureNames.forEach { string in
            let texture = shootAnimationAtlas.textureNamed(string)
            texture.filteringMode = .nearest
            shootAnimationTextures.append(texture)
        }
        shootAnimation = SKAction.animate(with: shootAnimationTextures, timePerFrame: 0.1)

    }
    
    private func setUpPhysicsWorld() {
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = .zero
    }
    
}
