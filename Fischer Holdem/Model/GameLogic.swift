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
    var preflopDecisionMade: Bool = false
    var flopDecisionMade: Bool = false
    var turnDecisionMade: Bool = false
    var riverDecisionMade: Bool = false
    
    init(hero: Player, opponent: Player) {
        self.gameStarted = true
        self.timeExpired = false
        self.haveWinner = false
        self.gamePhase = .preflop
        self.hero = hero
        self.opponent = opponent
        self.potSize = 0
        self.deck = Deck()
        self.betAmount = 0
    }
    
    private func startNewGame() {
        hero.hasFolded = false
        opponent.hasFolded = false
        self.haveWinner = false
    }
    
    func runGame(phase: GamePhase) {
            switch gamePhase {
            case .preflop:
                dealCards()
                postBlinds()
                
                if hero.isDealer && hero.chipCount != 0 {
                
                }
                self.gamePhase = .flop
            case .flop:
                dealFlop()
                if !hero.isDealer && hero.chipCount != 0 {
                } else if !opponent.isDealer && opponent.chipCount != 0 {
                }
            case .turn:
                dealTurn()
                if !hero.isDealer && hero.chipCount != 0 {
                } else if !opponent.isDealer && opponent.chipCount != 0 {
                }
                gamePhase = .river
            case .river:
                dealTurn(isRiver: true)
                if !hero.isDealer && hero.chipCount != 0 {
                } else if !opponent.isDealer && opponent.chipCount != 0 {
                }
                gamePhase = .showdown
            case .showdown:
                hero.playerHand?.0.revealCard()
                hero.playerHand?.1.revealCard()
                opponent.playerHand?.0.revealCard()
                opponent.playerHand?.1.revealCard()
                
               // self.haveWinner = true
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
        let moveToPot = SCNAction.move(to: SCNVector3(0, 18, 0), duration: 0.5)
        let heroBlind = hero.chips.childNode(withName: "dollar", recursively: true)
        heroBlind?.runAction(moveToPot)
        heroBlind?.name = "p.dollar"
        let opponentBlind = hero.chips.childNode(withName: "dollar", recursively: true)
        opponentBlind?.runAction(moveToPot)
        opponentBlind?.name = "p.dollar"
        if hero.isDealer {
            hero.chipCount -= 1
            opponent.chipCount -= 2
            self.potSize += 3
            let opponentBlind = hero.chips.childNode(withName: "dollar", recursively: true)
            opponentBlind?.runAction(moveToPot)
            opponentBlind?.name = "p.dollar"
        } else {
            opponent.chipCount -= 1
            hero.chipCount -= 2
            self.potSize += 3
            let heroBlind = hero.chips.childNode(withName: "dollar", recursively: true)
            heroBlind?.runAction(moveToPot)
            heroBlind?.name = "p.dollar"
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
    
    func fold() {
        hero.hasFolded = true
    }
    
    func bet(betAmount: UInt32) {
        hero.chipCount -= betAmount
        hero.chips.chipCount -= betAmount
        self.betAmount = 0
        self.potSize += betAmount
    }
    
    func check() {
    }
    
    func dealFlop(){
        let pos = SCNVector3(-5, 17, 0)
        let rotate = SCNAction.rotateBy(x: 0, y: 0, z: 4, duration: 1)
        for card in 0...2 {
            let moveToCenter = SCNAction.move(to: SCNVector3(pos.x + Float(4 * card), pos.y, pos.z), duration:0.5)
            let sequence = SCNAction.sequence([moveToCenter, rotate])
            let cardNode = deck.dealCard()
            cardNode.physicsBody?.isAffectedByGravity = false
            cardNode.runAction(sequence)
            cardNode.physicsBody?.isAffectedByGravity = true
        }
    }
    
    func dealTurn(isRiver: Bool = false) {
        var moveToTurn = SCNAction.move(to: SCNVector3(3, 17, 0), duration: 1)
        if isRiver {
            moveToTurn = SCNAction.move(to: SCNVector3(5, 17, 0), duration: 1)
        }
        let rotate = SCNAction.rotateBy(x: 0, y: 0, z: 4, duration: 1)
        let seqeunce = SCNAction.sequence([moveToTurn, rotate])
        let cardNode = deck.dealCard()
        cardNode.physicsBody?.isAffectedByGravity = false
        cardNode.runAction(seqeunce)
        cardNode.physicsBody?.isAffectedByGravity = true
    }
    
    
    
    
    
    
    
    
   
}

