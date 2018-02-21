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
    
    init(cardValue: (Rank, Suit)) {
        self.cardValue = cardValue
        super.init()
        self.geometry = SCNBox(width: 3, height: 4.2, length: 0.005, chamferRadius: 5)
        self.eulerAngles = SCNVector3(x: -30, y: 0, z: 0)
        self.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
        self.physicsBody?.categoryBitMask = CollisionCategoryCard
        self.physicsBody?.collisionBitMask = CollisionCategoryCard | CollisionCategoryChip | CollisionCategoryDealerButton | CollisionCategoryFloor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func colorizeCard() {
        let faceUpCard: String = String(describing: self.cardValue.rank) + String(describing: self.cardValue.suit)
        let frontMaterial = SCNMaterial()
        let backMaterial = SCNMaterial()
        let sideMaterial = SCNMaterial()
        sideMaterial.diffuse.contents = UIColor.white
        frontMaterial.diffuse.contents = UIImage(named: faceUpCard)
        backMaterial.diffuse.contents = UIImage(named: "cardSide3")
        let materials: [SCNMaterial] = [frontMaterial, sideMaterial, backMaterial, sideMaterial, sideMaterial, sideMaterial]
        self.geometry?.materials = materials
        self.geometry?.firstMaterial?.shininess = 5
       
    }
}

