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
    var heroToAct: Bool = true
    var haveWinner: Bool = true
    var potSize: UInt32 = 0
    var callAmount: UInt32 = 0
    var betAmount: UInt32 = 0
    var gamePhase: GamePhase
    var deck: Deck
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
        print("NEW GAME STARTED")
        if hero.chipCount <= 2 || opponent.chipCount <= 2 {
            print("GAME OVER! You lost the game, time to rebuy")
        }
        potSize = 0
        hero.contribution = 0
        opponent.contribution = 0
        betAmount = 0
        callAmount = 0
        gamePhase = .preflop
        boardCards = nil
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.nextPhase(phase: self.gamePhase)
            self.postBlinds()
            self.dealCards()
        }
    }
    
   func nextPhase(phase: GamePhase) {
    
    print("Is hero to act " + String(heroToAct))
    print("How much too call " + String(callAmount))
 
    print("Which street is it? " + String(describing: gamePhase))
    
    // add if statement in case hero or opponent is all in.
            switch gamePhase {
            case .preflop:
                if heroToAct {
                }
                //updateCallAmount()
               //self.gamePhase = .flop
            case .flop:
                dealFlop()
                if !opponent.isDealer {
                    randomActionDecision()
                }
                //self.gamePhase = .turn
            case .turn:
                dealTurn()
                if !opponent.isDealer {
                    randomActionDecision()
                }
               // self.gamePhase = .river
            case .river:
                dealTurn(isRiver: true)
                if !opponent.isDealer {
                    randomActionDecision()
                }
              //  self.gamePhase = .showdown
            case .showdown:
                hero.playerHand?.0.revealCard()
                hero.playerHand?.1.revealCard()
                opponent.playerHand?.0.revealCard()
                opponent.playerHand?.1.revealCard()
            }
        }
    
    func fold(player: Player) {
        player.hasFolded = true
        if hero.hasFolded {
            winner = opponent
        } else {
            winner = hero
        }
        winner?.chipCount += potSize
        player.foldCardsToCenter()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.haveWinner = true
        }
    }
    
    func bet(player: Player) {
        if betAmount > player.chipCount {
            betAmount = player.chipCount
        }
        player.chipCount -= betAmount
        player.contribution += betAmount
        potSize += betAmount
        customAmount(amount: betAmount, player: player)
        betAmount = 0
    }
    
    func call(player: Player) {
        if callAmount > player.chipCount {
            callAmount = player.chipCount
        }
        player.chipCount -= callAmount
        potSize += callAmount
        customAmount(amount: callAmount, player: player)
        callAmount = 0
        // preflop SB completion
        if gamePhase == .preflop && player.isDealer && potSize == 4 {
            if opponent.isDealer {
                heroToAct = true
            } else {
                randomActionDecision()
            }
        // all other calling situations
        } else {
            gamePhase = nextStreet(phase: gamePhase)
            nextPhase(phase: gamePhase)
        }
        //wentAllIn()
    }
    
    func check(player: Player) {
        // preflop BB check
        if gamePhase == .preflop && !player.isDealer {
            gamePhase = nextStreet(phase: gamePhase)
        }
        // flop, turn, river BB check
        if gamePhase != .preflop && !player.isDealer {
            if opponent.isDealer {
                randomActionDecision()
            } else {
                heroToAct = true
            }
        }
        // flop, turn, river BTN check back
        if gamePhase != .preflop && player.isDealer {
            gamePhase = nextStreet(phase: gamePhase)
        }
        nextPhase(phase: gamePhase)
    }
    
    func randomReactionDecision() {
        if let decision = ReactionChoice(rawValue: arc4random_uniform(3)) {
            print("Stupid AI makes random Reaction " + String(describing: decision))
            switch decision {
            case .fold:
                fold(player: opponent)
            case .call:
                call(player: opponent)
            case .raise:
                betAmount = (2 * callAmount) + arc4random_uniform(callAmount)
                bet(player: opponent)
                heroToAct = true
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
        }
    }
    
    func nextStreet(phase: GamePhase) -> GamePhase {
        let nextStreet = GamePhase(rawValue: phase.rawValue + 1)
        return nextStreet!
    }
    
    func randomActionDecision() {
        if let decision =  ActionChoice(rawValue: arc4random_uniform(3)) {
            print("Stupid AI makes random Action " + String(describing: decision))
            switch decision {
            case .fold:
                betAmount = arc4random_uniform(125) * potSize / 100 + 1
                bet(player: opponent)
                heroToAct = true
            case .check:
                check(player: opponent)
            case .bet:
                betAmount = arc4random_uniform(125) * potSize / 100 + 1
                bet(player: opponent)
                heroToAct = true
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
        }
    }
    
    private func dealCards() {
        hero.playerHand = (deck.dealCard(), deck.dealCard())
        opponent.playerHand = (deck.dealCard(), deck.dealCard())
        let dealOpponentAction = SCNAction.move(to: SCNVector3(-5 , 18, -13), duration: 0.5)
        let dealHeroAction = SCNAction.move(to: SCNVector3(2.5 , 16, 15), duration: 0.5)
        let dealOpponent2 = SCNAction.move(to: SCNVector3(-4.5 , 18, -13), duration: 1)
        let dealHero2 = SCNAction.move(to: SCNVector3(3 , 16.5, 14.5), duration: 1)
        hero.playerHand?.0.runAction(dealHeroAction)
        opponent.playerHand?.0.runAction(dealOpponentAction)
        hero.playerHand?.1.runAction(dealHero2)
        opponent.playerHand?.1.runAction(dealOpponent2)
    }
    
    private func postBlinds() {
        if hero.isDealer {
            hero.chipCount -= 1
            opponent.chipCount -= 2
            hero.contribution += 1
            opponent.contribution += 2
            self.potSize += 3
            customAmount(amount: 1, player: hero)
            customAmount(amount: 2, player: opponent)
        } else {
            opponent.chipCount -= 1
            hero.chipCount -= 2
            hero.contribution += 2
            opponent.contribution += 1
            self.potSize += 3
            customAmount(amount: 2, player: hero)
            customAmount(amount: 1, player: opponent)
        }
    }
    
    func updateCallAmount() {
        if hero.contribution < opponent.contribution {
            callAmount = opponent.contribution - hero.contribution
            hero.contribution = 0
            opponent.contribution = 0
            heroToAct = true
        } else if hero.contribution > opponent.contribution {
            callAmount = hero.contribution - opponent.contribution
            hero.contribution = 0
            opponent.contribution = 0
            heroToAct = false
            randomReactionDecision()
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
    
   
    
    
    
    
    
    func dealFlop(){
        let pos = SCNVector3(-8, 17, 0)
        let rotate = SCNAction.rotateBy(x: 0, y: 0, z: 4, duration: 1)
        for card in 0...2 {
            let moveToCenter = SCNAction.move(to: SCNVector3(pos.x + Float(4 * card), pos.y, pos.z), duration:0.5)
            let sequence = SCNAction.sequence([moveToCenter, rotate])
            let cardNode = deck.dealCard()
            cardNode.physicsBody?.isAffectedByGravity = false
            cardNode.runAction(sequence)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                cardNode.physicsBody?.isAffectedByGravity = true
                self.boardCards?.append(cardNode)
            }
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
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            cardNode.physicsBody?.isAffectedByGravity = true
            self.boardCards?.append(cardNode)
        }
    }
    
    func updateDeck() {
        self.deck.removeFromParentNode()
        deck = Deck()
    }
    
    func updateChips() {
        hero.chips.removeFromParentNode()
        opponent.chips.removeFromParentNode()
        hero.chips = Chips(chipCount: hero.chipCount)
        opponent.chips = Chips(chipCount: opponent.chipCount, isHero: false)
    }
    
    
    // for calling or raising any amount from avaialble chips on the table
    func customAmount(amount: UInt32, player: Player) {
        var amountLeft = amount
        let moveToCenter = SCNAction.move(to: SCNVector3(0, 17, 0), duration: 1)
        while amountLeft != 0 && player.isAllIn != true  {
            let chip25 = player.chips.childNode(withName: "twentyFiveDollars", recursively: true)
            let chip5 = player.chips.childNode(withName: "fiveDollars", recursively: true)
            let chip1 = player.chips.childNode(withName: "dollar", recursively: true)
            if amountLeft >= 25 {
                if chip25 != nil {
                    chip25?.runAction(moveToCenter)
                    chip25?.name = "inPot"
                    amountLeft -= 25
                } else if chip5 != nil {
                    chip5?.runAction(moveToCenter)
                    chip5?.name = "inPot"
                    amountLeft -= 5
                } else if chip1 != nil {
                    chip1?.runAction(moveToCenter)
                    chip1?.name = "inPot"
                    amountLeft -= 1
                }
            } else if amountLeft >= 5 {
                if chip5 != nil {
                    chip5?.runAction(moveToCenter)
                    chip5?.name = "inPot"
                    amountLeft -= 5
                } else if chip1 != nil {
                    chip1?.runAction(moveToCenter)
                    chip1?.name = "inPot"
                    amountLeft -= 1
                }
            } else if amountLeft > 0 {
                if chip1 != nil {
                    chip1?.runAction(moveToCenter)
                    chip1?.name = "inPot"
                    amountLeft -= 1
                } else if chip25 != nil {
                        let newChips = Chips(chipCount: 25)
                        chip25?.removeFromParentNode()
                        player.chips.addChildNode(newChips)
                    } else if chip5 != nil {
                        let newChips = Chips(chipCount: 5)
                        chip5?.removeFromParentNode()
                        player.chips.addChildNode(newChips)
                } else {
                    player.isAllIn = true
                }
            }
        }
        }
    
    
    
    
    }
    
    
    
    
    
    
    


