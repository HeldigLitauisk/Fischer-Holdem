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
    var potSize: UInt32
    var betAmount: UInt32
    let deck: Deck
    
    init(hero: Player, opponent: Player) {
        self.gameStarted = true
        self.timeExpired = false
        self.haveWinner = false
        self.gamePhase = .preflop
        self.hero = hero
        self.opponent = opponent
        self.potSize = 0
        self.deck = Deck()
        self.betAmount = 2
    }
    
    private func startNewGame() {
        hero.hasFolded = false
        opponent.hasFolded = false
        self.haveWinner = false
    }
    
    func runGame(phase: GamePhase) {
            switch gamePhase {
            case .preflop:
                if hero.isDealer && hero.chipCount != 0 {
                dealCards()
                postBlinds()
                }
    
                gamePhase = .flop
            case .flop:
                if !hero.isDealer && hero.chipCount != 0 {
                } else if !opponent.isDealer && opponent.chipCount != 0 {
                }
                gamePhase = .turn
            case .turn:
                if !hero.isDealer && hero.chipCount != 0 {
                } else if !opponent.isDealer && opponent.chipCount != 0 {
                }
                gamePhase = .river
            case .river:
                if !hero.isDealer && hero.chipCount != 0 {
                } else if !opponent.isDealer && opponent.chipCount != 0 {
                }
                gamePhase = .showdown
            case .showdown:
               // hero.playerHand?.0.revealCard()
             //   hero.playerHand?.1.revealCard()
             //   opponent.playerHand?.0.revealCard()
            //    opponent.playerHand?.1.revealCard()
                self.haveWinner = true
            }
        moveDealerButton()
        }
    
    
    
    private func dealCards() {
        hero.playerHand = (deck.dealCard(), deck.dealCard())
        opponent.playerHand = (deck.dealCard(), deck.dealCard())
        let dealOpponentAction = SCNAction.move(to: SCNVector3(3 , 16, -15), duration: 0.2)
        let dealHeroAction = SCNAction.move(to: SCNVector3(3 , 16, 15), duration: 0.2)
        hero.playerHand?.0.runAction(dealHeroAction)
        opponent.playerHand?.0.runAction(dealOpponentAction)
        hero.playerHand?.1.runAction(dealHeroAction)
        opponent.playerHand?.1.runAction(dealOpponentAction)
    }
    
    private func postBlinds() {
        if hero.isDealer {
            hero.chipCount -= 1
            opponent.chipCount -= 2
            self.potSize += 3
        } else {
            opponent.chipCount -= 1
            hero.chipCount -= 2
            self.potSize += 3
        }
    }
    
    private func moveDealerButton() {
        let tempValue = hero.isDealer
        hero.isDealer = opponent.isDealer
        opponent.isDealer = tempValue
    }
    
    func increaseBetAmount(betAmount: UInt32) {
        self.betAmount += betAmount
    }
    
    
    
    
    
    
    
   
}

