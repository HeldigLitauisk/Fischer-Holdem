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
    var decisionMade: Bool = true
    var haveWinner: Bool = false
    var potSize: UInt32 = 0
    var callAmount: UInt32 = 0
    var betAmount: UInt32 = 0
    var gamePhase: GamePhase
    let deck: Deck
    let hero: Player
    let opponent: Player
    var winner: Player?
    var boardCards: Array<Card>?
    
    init(hero: Player, opponent: Player) {
        self.gamePhase = .preflop
        self.deck = Deck()
        self.hero = hero
        self.opponent = opponent
    }
    
    func startNewGame() {
        hero.hasFolded = false
        opponent.hasFolded = false
        self.gamePhase = .preflop
        nextPhase(phase: gamePhase)
        //add a original deck
        //add updated chip
    }
    
   func nextPhase(phase: GamePhase) {
    // add if statement in case hero or opponent is all in.
            switch gamePhase {
            case .preflop:
                dealCards()
                postBlinds()
                self.gamePhase = .flop
            case .flop:
                dealFlop()
                self.gamePhase = .turn
            case .turn:
                dealTurn()
                self.gamePhase = .river
            case .river:
                dealTurn(isRiver: true)
                self.gamePhase = .showdown
            case .showdown:
                hero.playerHand?.0.revealCard()
                hero.playerHand?.1.revealCard()
                opponent.playerHand?.0.revealCard()
                opponent.playerHand?.1.revealCard()
                
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
            hero.contribution += 1
            opponent.contribution += 2
            self.potSize += 3
            let opponentBlind = hero.chips.childNode(withName: "dollar", recursively: true)
            opponentBlind?.runAction(moveToPot)
            opponentBlind?.name = "p.dollar"
        } else {
            opponent.chipCount -= 1
            hero.chipCount -= 2
            hero.contribution += 2
            opponent.contribution += 1
            self.potSize += 3
            let heroBlind = hero.chips.childNode(withName: "dollar", recursively: true)
            heroBlind?.runAction(moveToPot)
            heroBlind?.name = "p.dollar"
        }
    }
    
    func updateCallAmount() {
        if hero.contribution < opponent.contribution {
            callAmount = opponent.contribution - hero.contribution
            hero.contribution = 0
            opponent.contribution = 0
        }
    }
    
    func moveDealerButton() {
        let tempValue = hero.isDealer
        hero.isDealer = opponent.isDealer
        opponent.isDealer = tempValue
    }
    
    func increaseBetAmount(betAmount: UInt32) {
        self.betAmount += betAmount
    }
    
    func fold() {
        decisionMade = true
        hero.hasFolded = true
        haveWinner = true
        winner = opponent
    }
    
    func bet() {
        decisionMade = true
        hero.chipCount -= betAmount
        hero.contribution += betAmount
        self.potSize += betAmount
        self.betAmount = 0
    }
    
    func call() {
        decisionMade = true
        hero.chipCount -= callAmount
        hero.contribution += callAmount
        self.potSize += callAmount
        self.callAmount = 0
        nextPhase(phase: gamePhase)
    }
    
    func check() {
        decisionMade = true
        nextPhase(phase: gamePhase)
        print(gamePhase)
        print(callAmount)
    }
    
    func dealFlop(){
        let pos = SCNVector3(-8, 17, 0)
        let rotate = SCNAction.rotateBy(x: 0, y: 0, z: 4, duration: 1)
        for card in 0...2 {
            let moveToCenter = SCNAction.move(to: SCNVector3(pos.x + Float(4 * card), pos.y, pos.z), duration:0.5)
            let sequence = SCNAction.sequence([moveToCenter, rotate])
            let cardNode = deck.dealCard()
            cardNode.physicsBody?.isAffectedByGravity = false
            cardNode.runAction(sequence)
            cardNode.physicsBody?.isAffectedByGravity = true
            boardCards?.append(cardNode)
        }
    }
    
    func dealTurn(isRiver: Bool = false) {
        var moveToTurn = SCNAction.move(to: SCNVector3(3, 17, 0), duration: 1)
        if isRiver {
            moveToTurn = SCNAction.move(to: SCNVector3(6, 17, 0), duration: 1)
        }
        let rotate = SCNAction.rotateBy(x: 0, y: 0, z: 4, duration: 1)
        let seqeunce = SCNAction.sequence([moveToTurn, rotate])
        let cardNode = deck.dealCard()
        cardNode.physicsBody?.isAffectedByGravity = false
        cardNode.runAction(seqeunce)
        cardNode.physicsBody?.isAffectedByGravity = true
        boardCards?.append(cardNode)
    }
    
    
    
    
    
    
    
    
   
}

