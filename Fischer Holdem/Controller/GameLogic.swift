//
//  GameLogic.swift
//  Fischer Holdem
//
//  Created by Eimantas Urbutis on 18/02/2018.
//  Copyright © 2018 Urbut Corp. All rights reserved.
//

import Foundation

class GameLogic {
    let gamePhase: GamePhase
    
    init(gamePhase: GamePhase) {
        self.gamePhase = gamePhase
        
    }
    
    enum GamePhase: String {
        case preflop, flop, turn, river, showdown
    }
    
    func dealCards() {
        switch gamePhase {
        case .preflop:
            break
        default:
            break
        }
    }

}
