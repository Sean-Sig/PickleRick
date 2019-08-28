//
//  MenuScene.swift
//  pickleRick
//
//  Created by Sean Siggard on 4/28/18.
//  Copyright © 2018 Caroline Begbie. All rights reserved.
//

import Foundation
import SpriteKit

class GameOver: SKScene {
    var didWin: Bool
    
    var count = 0

    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    init(size: CGSize, didWin: Bool) {
        self.didWin = didWin
        super.init(size: size)
        scaleMode = .aspectFill
    }
    
    override func didMove(to view: SKView) {
  
        if didWin == false{
            let winLabel = SKLabelNode(text: "Game Over")
            winLabel.position = CGPoint(x: frame.midX, y: frame.midY)
            winLabel.fontSize = 95
            winLabel.fontName = "GillSans-UltraBold"
            winLabel.fontColor = .white
            self.addChild(winLabel)
            backgroundColor = SKColor.black
            count = 0
            
        }
        else{
            let winLabel = SKLabelNode(text: "You Win!!")
            winLabel.position = CGPoint(x: frame.midX, y: frame.midY)
            winLabel.fontSize = 95
            winLabel.fontColor = .white
            winLabel.fontName = "Copperplate-Bold"
            self.addChild(winLabel)
            backgroundColor = SKColor.black
        }

    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let gameScene = GameScene(fileNamed: "GameScene") else {
            fatalError("GameScene not found")
        }
        let transition = SKTransition.doorsOpenHorizontal(withDuration: 2.0)
        gameScene.scaleMode = .aspectFill
        view?.presentScene(gameScene, transition: transition)
    }
}
