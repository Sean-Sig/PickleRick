import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    
    let playerSpeed: CGFloat = 200
    let BadGuySpeed: CGFloat = 35
    
    var player: SKSpriteNode?
    var BadGuys: [SKSpriteNode] = []
    var goal: SKSpriteNode?
   
    
    var lastTouch: CGPoint? = nil
    
    override func didMove(to view: SKView) {
        
        view.showsPhysics = true
        
        physicsWorld.contactDelegate = self
    
        player = childNode(withName: "pickle") as? SKSpriteNode
        
        for child in children {
            if child.name == "badGuy" {
                if let child = child as? SKSpriteNode {
                
                    BadGuys.append(child)
                }
            }
        }
        
        goal = childNode(withName: "portal") as? SKSpriteNode
        
        updateCamera()
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>,
                               with event: UIEvent?) {
        handleTouches(touches)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>,
                               with event: UIEvent?) {
        handleTouches(touches)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>,
                               with event: UIEvent?) {
        handleTouches(touches)
    }
    
    fileprivate func handleTouches(_ touches: Set<UITouch>) {
        lastTouch = touches.first?.location(in: self)
    }
    
    override func didSimulatePhysics() {
        if player != nil {
            updatePlayer()
            updateBadGuys()
        }
    }

    fileprivate func shouldMove(currentPosition: CGPoint,
                                touchPosition: CGPoint) -> Bool {
        guard let player = player else { return false }
        return abs(currentPosition.x - touchPosition.x) > player.frame.width / 2 ||
            abs(currentPosition.y - touchPosition.y) > player.frame.height / 2
    }

    fileprivate func updatePlayer() {
        guard let player = player,
            let touch = lastTouch
            else { return }
        let currentPosition = player.position
        if shouldMove(currentPosition: currentPosition,
                      touchPosition: touch) {
           updatePosition(for: player, to: touch, speed: playerSpeed)
            updateCamera()
        } else {
            player.physicsBody?.isResting = true
        }
    }
    
    fileprivate func updateCamera() {
        guard let player = player else { return }
        camera?.position = player.position
    }
    
    func updateBadGuys() {
        guard let goal = goal else { return }
        let targetPosition = goal.position
        
        for badGuy in BadGuys {
            updatePosition(for: badGuy, to: targetPosition, speed: BadGuySpeed)
        }
    }
    
    fileprivate func updatePosition(for sprite: SKSpriteNode,
                                    to target: CGPoint,
                                    speed: CGFloat) {
        let currentPosition = sprite.position
        let angle = CGFloat.pi + atan2(currentPosition.y - target.y,
                                       currentPosition.x - target.x)
        let rotateAction = SKAction.rotate(toAngle: angle + (CGFloat.pi*0.5),
                                           duration: 0)
        sprite.run(rotateAction)

        let velocityX = speed * cos(angle)
        let velocityY = speed * sin(angle)

        let newVelocity = CGVector(dx: velocityX, dy: velocityY)
        sprite.physicsBody?.velocity = newVelocity
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
            
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        

        if firstBody.categoryBitMask == BadGuys[0].physicsBody?.categoryBitMask &&
            secondBody.categoryBitMask == goal?.physicsBody?.categoryBitMask {
            
            gameOver(false)
        } else if firstBody.categoryBitMask == player?.physicsBody?.categoryBitMask &&
            secondBody.categoryBitMask == goal?.physicsBody?.categoryBitMask {
            gameOver(true)
        }
    }
    
    fileprivate func gameOver(_ didWin: Bool) {
        let menuScene = GameOver(size: size, didWin: didWin)
        
        if didWin == false {
            let transition = SKTransition.fade(with: .red, duration: 2.0)
            view?.presentScene(menuScene, transition: transition)
        }
        else{
            let transition = SKTransition.crossFade(withDuration: 1.0)
            view?.presentScene(menuScene, transition: transition)
        }
 
    }

}




