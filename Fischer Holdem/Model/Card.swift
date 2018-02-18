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
    var cardValue: (rank: Rank, suit: Suit) {
        get { return self.cardValue }
        set { self.cardValue = newValue}
    }
    
    init(cardValue: (Rank, Suit), nodeName: String = "card") {
        super.init()
        self.cardValue = cardValue
        self.name = nodeName
        self.geometry = SCNBox(width: 3, height: 5, length: 0.1, chamferRadius: 5)
        self.eulerAngles = SCNVector3(x: -30, y: 0, z: 0)
        self.geometry?.firstMaterial?.shininess = 1
        self.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
        self.physicsBody?.categoryBitMask = CollisionCategoryCard
        self.physicsBody?.collisionBitMask = CollisionCategoryCard | CollisionCategoryChip | CollisionCategoryDealerButton
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
