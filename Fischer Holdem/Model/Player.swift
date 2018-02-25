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
    let isHero: Bool
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
    
    
    
}
