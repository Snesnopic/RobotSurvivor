//
//  Joystick.swift
//  UntitledGame
//
//  Created by Antonio Claudio Pepe on 07/12/23.
//

import SpriteKit
import Foundation
    
    
class Joystick: SKScene {
    var playerNode: SKSpriteNode
    var joystickBase: SKSpriteNode!
    var joystickKnob: SKSpriteNode!
    var isJoystickActive = false
    
   required init(player: SKSpriteNode) {
        
        self.playerNode = player
       
       super.init(size: CGSize(width: 100, height: 100))
       
       
        func didMove(to view: SKView) {
            // Create the base of the joystick
            joystickBase = SKSpriteNode(imageNamed: "joystickBase")
            joystickBase.position = CGPoint(x: 100, y: 100) // Set position
            addChild(joystickBase)
            
            // Create the knob of the joystick
            joystickKnob = SKSpriteNode(imageNamed: "joystickKnob")
            joystickKnob.position = joystickBase.position // Initially centered on the base
            addChild(joystickKnob)
        }
        }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            guard let touch = touches.first else { return }
            let touchLocation = touch.location(in: self)
            
            if joystickBase.contains(touchLocation) {
                isJoystickActive = true
            }
        }
        
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
            guard let touch = touches.first else { return }
            guard isJoystickActive else { return }
            
            let joystickBaseRadius = joystickBase.frame.size.width / 2
            let touchLocation = touch.location(in: self)
            
            // Calculate the distance and angle from the joystick base to the touch
            let deltaX = touchLocation.x - joystickBase.position.x
            let deltaY = touchLocation.y - joystickBase.position.y
            let distance = hypot(deltaX, deltaY)
            let angle = atan2(deltaY, deltaX)
            
            // Restrict the knob within the joystick base using the distance
            if distance <= joystickBaseRadius {
                joystickKnob.position = touchLocation
            } else {
                let x = joystickBase.position.x + cos(angle) * joystickBaseRadius
                let y = joystickBase.position.y + sin(angle) * joystickBaseRadius
                joystickKnob.position = CGPoint(x: x, y: y)
            }
            
            // Use the angle and distance to control movement
            let speed: CGFloat = 5.0
            let xMovement = cos(angle) * distance / joystickBaseRadius * speed
            let yMovement = sin(angle) * distance / joystickBaseRadius * speed
            
            // Applied the movement to your character or game objects
            playerNode.position.x += xMovement
            playerNode.position.y += yMovement
        }
        
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
            guard isJoystickActive else { return }
            joystickKnob.position = joystickBase.position // Reset knob position
            isJoystickActive = false
        }
    }
