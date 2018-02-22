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
    
    func revealCard() {
        let pos = self.position
        let upAction = SCNAction.move(to: SCNVector3(pos.x, pos.y + 0.5 , pos.z), duration: 0.2)
        let rotate = (SCNAction.rotateBy(x: 0, y: 0, z: 2, duration: 0.2))
        self.runAction(upAction)
        self.runAction(rotate)
    }
    
    /*func peakAtCard() {
        let pos = self.position
        let moveUp = SCNAction.move(to: SCNVector3(pos.x, pos.y, pos.z - 0.3), duration: 0.2)
        let peakUp = SCNAction.rotateBy(x: -1.5, y: 0, z: 0, duration: 1)
        let peakDown = SCNAction.rotateBy(x: 1.5, y: 0, z: 0, duration: 0.5)
        let sequence = SCNAction.sequence([moveUp, peakUp, peakDown])
        self.runAction(sequence)
        } */

}

