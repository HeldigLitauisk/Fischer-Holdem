//
//  Player.swift
//  Fischer Holdem
//
//  Created by Eimantas Urbutis on 21/02/2018.
//  Copyright © 2018 Urbut Corp. All rights reserved.
//

import Foundation
import SceneKit

class Player {
    var isHero: Bool
    var isDealer: Bool
    var isAllIn: Bool = false
    var hasFolded: Bool = false
    var chipCount: UInt32
    var contribution: UInt32 = 0
    var chips: Chips
    var playerHand: (Card, Card)?
    
    init(chipCount: UInt32, isHero: Bool = true) {
        self.isHero = isHero
        self.isDealer = isHero  // for first hand only
        self.chipCount  = chipCount
        self.chips = Chips(chipCount: chipCount, isHero: isHero)
    }
    
    func foldCardsToCenter() {
        let foldCards = SCNAction.move(to: SCNVector3(0,18,0), duration: 0.5)
        self.playerHand?.0.runAction(foldCards)
        self.playerHand?.1.runAction(foldCards)
    }
}
