//
//  Joystick.swift
//  UntitledGame
//
//  Created by Antonio Claudio Pepe on 07/12/23.
//

import SpriteKit
import Foundation


class Joystick: SKScene {
    var gameSceneReference: GameScene
    var playerNode: SKSpriteNode
    var joystickBase: SKShapeNode!
    var joystickKnob: SKShapeNode!
    var isJoystickActive = false
    var angle: CGFloat = 0.0
    
    required init(player: SKSpriteNode, gameSceneReference: GameScene) {
        self.gameSceneReference = gameSceneReference
        self.playerNode = player
        super.init(size: CGSize(width: 100, height: 100))
        self.backgroundColor = UIColor.clear
        // Create the base of the joystick
//        let circlePath = UIBezierPath(ovalIn: CGRect(x: -50, y: -50, width: 100, height: 100))
        joystickBase = SKShapeNode(circleOfRadius: 50)
        joystickBase.fillColor = UIColor.white.withAlphaComponent(0.5)
        addChild(joystickBase)
        joystickBase.position = CGPoint(x: 50, y: 50)
        // Create the knob of the joystick
        joystickKnob = SKShapeNode(circleOfRadius: 23)
        joystickKnob.fillColor = UIColor.white
        joystickKnob.position = joystickBase.position // Initially centered on the base
        addChild(joystickKnob)
    }

    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let touchLocation = touch.location(in: self)
        if !isJoystickActive {
            joystickBase.position = CGPoint(x: touchLocation.x, y: touchLocation.y)
            joystickKnob.position = joystickBase.position
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        if !isJoystickActive {
            self.alpha = 0.0
        }
        else {
            self.alpha = 1.0
            let deltaTime = gameSceneReference.deltaTime
            // Use the angle and distance to control movement
            let speed: CGFloat = playerNode.userData?.value(forKey: "speed") as! CGFloat
            let xMovement = cos(angle) * speed * deltaTime
            let yMovement = sin(angle) * speed * deltaTime
            // Apply the movement to your character or game objects
            // For example:
            playerNode.position.x += xMovement
            playerNode.position.y += yMovement
            gameSceneReference.healthBar.children.forEach { node in
                node.position.x += xMovement
                node.position.y += yMovement
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        // Joystick is not active if you don't move your touch from the base
        isJoystickActive = !(touch.location(in: self).x == joystickBase.position.x && touch.location(in: self).y == joystickBase.position.y)
        let joystickBaseRadius = joystickBase.frame.size.width / 4
        let touchLocation = touch.location(in: self)
        // Calculate the distance and angle from the joystick base to the touch
        let deltaX = touchLocation.x - joystickBase.position.x
        let deltaY = touchLocation.y - joystickBase.position.y
        let distance = hypot(deltaX, deltaY)
        angle = atan2(deltaY, deltaX)
        // Restrict the knob within the joystick base using the distance
        if distance <= joystickBaseRadius {
            joystickKnob.position = touchLocation
        } else {
            let x = joystickBase.position.x + cos(angle) * joystickBaseRadius
            let y = joystickBase.position.y + sin(angle) * joystickBaseRadius
            joystickKnob.position = CGPoint(x: x, y: y)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard isJoystickActive else { return }
        joystickKnob.position = joystickBase.position // Reset knob position
        isJoystickActive = false
    }
}
