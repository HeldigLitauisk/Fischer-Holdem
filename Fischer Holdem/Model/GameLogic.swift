//
//  GameLogic.swift
//  Fischer Holdem
//
//  Created by Eimantas Urbutis on 21/02/2018.
//  Copyright © 2018 Urbut Corp. All rights reserved.
//

import Foundation
import SceneKit

class GameLogic {
    var gameStarted: Bool
    var timeExpired: Bool
    var flopCards: (Card, Card, Card)?
    var turnCard: Card?
    var riverCard: Card?
    var gamePhase: GamePhase
    var haveWinner: Bool
    var winner: Player?
    let hero: Player
    let opponent: Player
    
    init(hero: Player, opponent: Player) {
        self.gameStarted = true
        self.timeExpired = false
        self.haveWinner = false
        self.gamePhase = .preflop
        self.hero = hero
        self.opponent = opponent
    }
    
    func startNewGame(deck: Deck) {
        hero.hasFolded = false
        opponent.hasFolded = false
        self.haveWinner = false
        
        while !haveWinner {
            switch gamePhase {
            case .preflop:
                // Assigns cards values to players
                hero.playerHand = (deck.dealCard(), deck.dealCard())
                opponent.playerHand = (deck.dealCard(), deck.dealCard())
                // Deals cards to players
                let dealOpponentAction = SCNAction.move(to: SCNVector3(3 , 16, -15), duration: 0.2)
                let dealHeroAction = SCNAction.move(to: SCNVector3(3 , 16, 15), duration: 0.2)
                hero.playerHand?.0.runAction(dealHeroAction)
                opponent.playerHand?.0.runAction(dealOpponentAction)
                hero.playerHand?.1.runAction(dealHeroAction)
                opponent.playerHand?.1.runAction(dealOpponentAction)
                // 
                gamePhase = .flop
            case .flop:
                if !hero.isButton && hero.chipCount != 0 {
                } else if !opponent.isButton && opponent.chipCount != 0 {
                }
                gamePhase = .turn
            case .turn:
                if !hero.isButton && hero.chipCount != 0 {
                } else if !opponent.isButton && opponent.chipCount != 0 {
                }
                gamePhase = .river
            case .river:
                if !hero.isButton && hero.chipCount != 0 {
                } else if !opponent.isButton && opponent.chipCount != 0 {
                }
                gamePhase = .showdown
            case .showdown:
               // hero.playerHand?.0.revealCard()
             //   hero.playerHand?.1.revealCard()
             //   opponent.playerHand?.0.revealCard()
            //    opponent.playerHand?.1.revealCard()
                self.haveWinner = true
            }
        }
    }
    
    
    
    
    enum GamePhase: String {
        case preflop, flop, turn, river, showdown
    }
    
    enum ActionChoice: String {
        case fold, check, bet
    }
    
    enum FacingAction: String {
        case fold, call, raise
    }
}

