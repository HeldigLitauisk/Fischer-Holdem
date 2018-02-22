//
//  Player.swift
//  Fischer Holdem
//
//  Created by Eimantas Urbutis on 21/02/2018.
//  Copyright © 2018 Urbut Corp. All rights reserved.
//

import Foundation

class Player {
    var isButton: Bool
    var isHuman: Bool
    var hasFolded: Bool
    var chipCount: UInt32
    var playerHand: (Card, Card)?
    var isPlaying: Bool
    
    init(chipCount: UInt32) {
        self.isHuman = true
        self.isButton = false
        self.hasFolded = false
        self.chipCount  = chipCount
        self.isPlaying = true
    }
    
}
