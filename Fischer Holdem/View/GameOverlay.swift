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
        let faceUpCard: String = String(describing: cardNode.cardValue.rank) + String(describing: cardNode.cardValue.suit)
        let cardSprite = SKSpriteNode(imageNamed: faceUpCard)
        cardSprite.scale(to: CGSize(width: 120, height: 168))
        heroCards.append(cardSprite)
        let numberOfCards = CGFloat(heroCards.count)
        cardSprite.position = CGPoint(x: -size.width / 2 + 130 * numberOfCards , y: size.height / 2 - 150)
       addChild(cardSprite)
    }
    
}
