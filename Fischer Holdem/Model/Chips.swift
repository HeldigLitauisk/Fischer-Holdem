//
//  Chips.swift
//  Fischer Holdem
//
//  Created by Eimantas Urbutis on 20/02/2018.
//  Copyright © 2018 Urbut Corp. All rights reserved.
//

import Foundation
import SceneKit

class Chips: SCNNode {
    let chipCount: UInt32
    let isHero: Bool
   // private var chipsCreated: (dollar: UInt32, dollar5: UInt32, dollar25: UInt32)?
    
    init(chipCount: UInt32, isHero: Bool = true) {
        self.isHero = isHero
        self.chipCount = chipCount
        super.init()
        self.name = "chips"
        createChipNode()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // not really using atm
    enum ChipValue: UInt32 {
        case dollar = 1, fiveDollars = 5, twentyFiveDollars = 25
    }
    
    private func calculateNumberOfChips(chipCount: UInt32) -> (dollar: UInt32, dollar5: UInt32, dollar25: UInt32) {
        var dollar = chipCount
        var dollar5: UInt32 = 0
        var dollar25: UInt32 = 0
        
        if dollar > 100 {
            dollar25 =  (dollar - 100) / 25
            dollar = 100 + dollar % 25
        }
        if dollar > 20 {
            dollar5 = (dollar - 20) / 5
            dollar = 20 + dollar % 5
        }
        return (dollar, dollar5, dollar25)
    }
    
    
    private func chipNode(chipValue: ChipValue) -> SCNNode {
        let chipNode = SCNNode()
        chipNode.geometry = SCNCylinder(radius: 1, height: 0.1)
        chipNode.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
        chipNode.physicsBody?.categoryBitMask = CollisionCategoryChip
        chipNode.physicsBody?.collisionBitMask = CollisionCategoryCard | CollisionCategoryDealerButton | CollisionCategoryFloor  | CollisionCategoryTable | CollisionCategoryChip
        chipNode.name = String(describing: chipValue)
        chipNode.geometry?.firstMaterial?.diffuse.contents = UIImage(named:String(describing: chipValue))
        chipNode.geometry?.firstMaterial?.shininess = 1
        return chipNode
    }
    
    private func createChipNode() {
        var chip1 = SCNVector3(x: 0, y: 18, z: 15)
        var chip5 = SCNVector3(x: -2.2, y: 18, z: 12.8)
        var chip25 = SCNVector3(x: -4.4, y: 18, z: 10.6)
        if !isHero {
            chip1 = SCNVector3(x: 0, y: 18, z: -15)
            chip5 = SCNVector3(x: 2.2, y: 18, z: -12.8)
            chip25 = SCNVector3(x: 4.4, y: 18, z: -10.6)
        }
        let numberOfChips = calculateNumberOfChips(chipCount: self.chipCount)
        for chip in 0...numberOfChips.dollar25 {
            let newChip = chipNode(chipValue: ChipValue.twentyFiveDollars)
            newChip.position = chip25
            if chip % 15 == 0 && chip != 0  {
                chip25 = SCNVector3(x: newChip.position.x - 2.05, y: newChip.position.y, z: newChip.position.z + 2.05)
            }
            if chip != 0 {
                self.addChildNode(newChip)
            }
        }
        for chip in 0...numberOfChips.dollar5 {
            let newChip = chipNode(chipValue: ChipValue.fiveDollars)
            newChip.position = chip5
            if chip % 15 == 0 && chip != 0 {
                chip5 = SCNVector3(x: newChip.position.x - 2.05, y: newChip.position.y, z: newChip.position.z + 2.05)
            }
            if chip != 0 {
                self.addChildNode(newChip)
            }
        }
        for chip in 0...numberOfChips.dollar {
            let newChip = chipNode(chipValue: ChipValue.dollar)
            newChip.position = chip1
            if chip % 15 == 0 && chip != 0 {
                chip1 = SCNVector3(x: newChip.position.x - 2, y: newChip.position.y, z: newChip.position.z + 2)
            }
            if chip != 0 {
                self.addChildNode(newChip)
            }
        }
    }
    
    
  /*  static func minimumNumberOfChips(chipCount: UInt32) -> (dollar: UInt32, dollar5: UInt32, dollar25: UInt32) {
        var dollar = chipCount
        var dollar5: UInt32 = 0
        var dollar25: UInt32 = 0
        
        dollar25 = dollar / 25
        dollar = dollar % 25
        dollar5 = dollar / 5
        dollar = dollar % 5
        return (dollar, dollar5, dollar25)
    }
    */
}

