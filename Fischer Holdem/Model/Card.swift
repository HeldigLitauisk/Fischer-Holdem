//
//  Card.swift
//  Fischer Holdem
//
//  Created by Eimantas Urbutis on 17/02/2018.
//  Copyright © 2018 Urbut Corp. All rights reserved.
//

import Foundation
import SceneKit

class Card: SCNNode {
    let cardValue: (rank: Rank, suit: Suit)
    
    init(cardValue: (Rank, Suit), nodeName: String = "card") {
        self.cardValue = cardValue
        super.init()
        self.name = nodeName
        self.position = SCNVector3(0,50,0)
        self.geometry = SCNBox(width: 3, height: 4.2, length: 0.1, chamferRadius: 5)
        self.eulerAngles = SCNVector3(x: -30, y: 0, z: 0)
        self.geometry?.firstMaterial?.shininess = 1
        self.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
        self.physicsBody?.categoryBitMask = CollisionCategoryCard
        self.physicsBody?.collisionBitMask = CollisionCategoryCard | CollisionCategoryChip | CollisionCategoryDealerButton
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    enum Suit: Int {
        case heart = 0, daimond, club, spade
    }
    
    enum Rank: Int {
        case deuce = 0, three, four, five, six, seven, eight, nine, ten, jack, queen, king, ace
    }
    
    func deckBuilder() -> Array<(rank: Rank, suit: Suit)> {
        var deck: Array<(rank: Rank, suit: Suit)> = []
        for _ in 1...52 {
            let randomRank = Rank(rawValue: Int(arc4random_uniform(13)))
            let randomSuit = Suit(rawValue: Int(arc4random_uniform(4)))
            deck.append((rank: randomRank!, suit: randomSuit!))
        }
        return deck
    }
    
    
}
