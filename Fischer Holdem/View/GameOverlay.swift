//
//  GameOverlay.swift
//  Fischer Holdem
//
//  Created by Eimantas Urbutis on 19/02/2018.
//  Copyright © 2018 Urbut Corp. All rights reserved.
//
import SceneKit
import SpriteKit

class GameOverlay: SKScene {
    var heroCards: [SKSpriteNode] = []
    
    override init(size: CGSize) {
        super.init(size: size)
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
      scaleMode = .resizeFill
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func showCard(cardNode: Card) {
        let cardImageName: String = String(describing: cardNode.cardValue.rank) + String(describing: cardNode.cardValue.suit)
        let cardSprite = SKSpriteNode(imageNamed: cardImageName)
        cardSprite.scale(to: CGSize(width: 80, height: 112))
        cardSprite.position = CGPoint(x: 0, y: size.height / 2 - 100)
        self.addChild(cardSprite)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.removeAllChildren()
        }
    }
    
}
