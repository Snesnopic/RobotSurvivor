import SpriteKit
import Foundation

class GameScene: SKScene {
    
    var player: SKSpriteNode!
    var joystick: Joystick!

    override func didMove(to view: SKView) {
        // Create and position the player
        player = SKSpriteNode(color: .red, size: CGSize(width: 50, height: 50))
        player.position = CGPoint(x: size.width / 2, y: size.height / 2)
        addChild(player)
        
        // Initialize the joystick with the player node
        joystick = Joystick(player: player)
        
        // Add the joystick to the scene
        addChild(joystick.joystickBase)
        addChild(joystick.joystickKnob)

        // Additional setup for the player's physics body, if required
        player.physicsBody = SKPhysicsBody(rectangleOf: player.size)
        player.physicsBody?.affectedByGravity = false
        player.physicsBody?.allowsRotation = false
    }

    override func update(_ currentTime: TimeInterval) {
        // Your game's update logic here
    }

    // Forward touch events to the joystick
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        joystick.touchesBegan(touches, with: event)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        joystick.touchesMoved(touches, with: event)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        joystick.touchesEnded(touches, with: event)
    }
}
