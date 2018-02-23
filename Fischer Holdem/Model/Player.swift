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
    var isDealer: Bool
    var isHuman: Bool
    var hasFolded: Bool
    var chipCount: UInt32
    var playerHand: (Card, Card)?
    var isPlaying: Bool
    var chips: Chips
    
    init(chipCount: UInt32) {
        self.isHuman = true
        self.isDealer = false
        self.hasFolded = false
        self.chipCount  = chipCount
        self.isPlaying = true
        self.chips = Chips(chipCount: chipCount)
    }
    
    func fold() {
        self.hasFolded = true
    }
    
    func bet(betAmount: UInt32) {
        self.chipCount -= betAmount
        self.chips.chipCount -= betAmount
    }
    
}
