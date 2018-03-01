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
    var heroToAct: Bool = false
    var computerToAct: Bool = false
    var haveWinner: Bool = true
    var potSize: UInt32 = 0
    var betAmount: UInt32 = 0
    var callAmount: UInt32 = 0
    var gamePhase: GamePhase
    var deck: Deck
    let hero: Player
    let opponent: Player
    var winner: Player? 
    var boardCards: Array<Card> = []
    var chipsInPot: Array<SCNNode> = []
    
    
    init(hero: Player, opponent: Player) {
        self.gamePhase = .preflop
        self.deck = Deck()
        self.hero = hero
        self.opponent = opponent
    }
    
    func startNewGame() {
        print("NEW GAME STARTED")
        potSize = 0
        betAmount = 0
        callAmount = 0
        hero.hasFolded = false
        opponent.hasFolded = false
        hero.isDealer = !hero.isDealer
        opponent.isDealer = !opponent.isDealer
        gamePhase = .preflop
        boardCards = []
        chipsInPot = []
        computerToAct = false
        heroToAct = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.dealCards()
            self.postBlinds()
            self.nextPhase(phase: self.gamePhase)
        }
    }
    
   func nextPhase(phase: GamePhase) {
    // add if statement in case hero or opponent is all in.
            switch gamePhase {
            case .preflop:
                updateCallAmount()
                if opponent.isDealer {
                    computerToAct = false
                    heroToAct = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        self.randomReactionDecision()
                    }
                } else {
                    heroToAct = true
                }
            case .flop:
                dealFlop()
                if !opponent.isDealer {
                    computerToAct = false
                    heroToAct = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        self.randomActionDecision()
                    }
                } else {
                    heroToAct = true
                }
            case .turn:
                dealTurn()
                if !opponent.isDealer {
                    computerToAct = false
                    heroToAct = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        self.randomActionDecision()
                    }
                } else {
                    heroToAct = true
                }
            case .river:
                dealTurn(isRiver: true)
                if !opponent.isDealer {
                    computerToAct = false
                    heroToAct = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        self.randomActionDecision()
                    }
                } else {
                    heroToAct = true
                }
            case .showdown:
                computerToAct = false
                heroToAct = false
                hero.playerHand?.0.revealCard()
                hero.playerHand?.1.revealCard()
                opponent.playerHand?.0.revealCard()
                opponent.playerHand?.1.revealCard()
                let determineWinner = HandStrength(player1: hero, player2: opponent, board: boardCards)
                print(determineWinner.isSplit)
                if !determineWinner.isSplit {
                    winner = determineWinner.winner
                    print(determineWinner.winnerHandStrength!)
                    print(determineWinner.winnerHandRank!)
                    winner?.chipCount += potSize
                    giveChipsToWinner()
                } else {
                    hero.chipCount += potSize / 2
                    opponent.chipCount += potSize / 2
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 6) {
                    self.haveWinner = true
                }
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
        giveChipsToWinner()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
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
        if player.isHero {
            computerToAct = true
        } else {
            heroToAct = true
        }
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
                computerToAct = false
                heroToAct = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    self.randomActionDecision()
                }
            }
        // all other calling situations
        } else {
            gamePhase = nextStreet(phase: gamePhase)
            nextPhase(phase: gamePhase)
            moveChipsToPot()
        }
        //wentAllIn()
    }
    
    func check(player: Player) {
        // preflop BB check
        if gamePhase == .preflop && !player.isDealer {
            gamePhase = nextStreet(phase: gamePhase)
            nextPhase(phase: gamePhase)
            moveChipsToPot()
        }
        // flop, turn, river BB check
        if gamePhase != .preflop && !player.isDealer {
            if opponent.isDealer {
                computerToAct = false
                heroToAct = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    self.randomActionDecision()
                }
            } else if hero.isDealer {
                heroToAct = true
            }
        }
        // flop, turn, river BTN check back
        if gamePhase != .preflop && player.isDealer {
            gamePhase = nextStreet(phase: gamePhase)
            nextPhase(phase: gamePhase)
        }
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
            }
        }
    }
    
    func nextStreet(phase: GamePhase) -> GamePhase {
        let nextStreet = GamePhase(rawValue: phase.rawValue + 1)
        return nextStreet!
    }
    
    func randomActionDecision() {
        if let decision =  ActionChoice(rawValue: arc4random_uniform(2) + 1) {
            print("Stupid AI makes random Action " + String(describing: decision))
            switch decision {
            case .fold:
                fold(player: opponent)
            case .check:
                check(player: opponent)
            case .bet:
                betAmount = arc4random_uniform(125) * potSize / 100 + 1
                bet(player: opponent)
            }
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
            computerToAct = false
        } else if hero.contribution > opponent.contribution {
            callAmount = hero.contribution - opponent.contribution
            hero.contribution = 0
            opponent.contribution = 0
            heroToAct = false
            computerToAct = true
        }
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
                self.boardCards.append(cardNode)
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
            self.boardCards.append(cardNode)
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
        let pos = player.chips.childNode(withName: "dollar", recursively: true)?.position ?? SCNVector3(0,18,0)
        var amountLeft = amount
        let moveToCenter = SCNAction.move(to: SCNVector3(pos.x, pos.y, pos.z / 3), duration: 1)
        while amountLeft != 0 && player.isAllIn != true  {
            let chip25 = player.chips.childNode(withName: "twentyFiveDollars", recursively: true)
            let chip5 = player.chips.childNode(withName: "fiveDollars", recursively: true)
            let chip1 = player.chips.childNode(withName: "dollar", recursively: true)
            if amountLeft >= 25 {
                if chip25 != nil {
                    chip25?.runAction(moveToCenter)
                    chip25?.name = "inPot"
                    chipsInPot.append(chip25!)
                    amountLeft -= 25
                } else if chip5 != nil {
                    chip5?.runAction(moveToCenter)
                    chip5?.name = "inPot"
                    chipsInPot.append(chip5!)
                    amountLeft -= 5
                } else if chip1 != nil {
                    chip1?.runAction(moveToCenter)
                    chip1?.name = "inPot"
                    chipsInPot.append(chip1!)
                    amountLeft -= 1
                }
            } else if amountLeft >= 5 {
                if chip5 != nil {
                    chip5?.runAction(moveToCenter)
                    chip5?.name = "inPot"
                    chipsInPot.append(chip5!)
                    amountLeft -= 5
                } else if chip1 != nil {
                    chip1?.runAction(moveToCenter)
                    chip1?.name = "inPot"
                    chipsInPot.append(chip1!)
                    amountLeft -= 1
                }
            } else if amountLeft > 0 {
                if chip1 != nil {
                    chip1?.runAction(moveToCenter)
                    chip1?.name = "inPot"
                    chipsInPot.append(chip1!)
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
    
    func giveChipsToWinner() {
        let pos = winner?.chips.childNode(withName: "dollar", recursively: true)?.position ?? SCNVector3(0,18,0)
        let giveToWinner = SCNAction.move(to: pos, duration: 1)
        for chip in chipsInPot {
            chip.runAction(giveToWinner)
        }
    }
    
    func moveChipsToPot() {
        let moveToPot = SCNAction.move(to: SCNVector3(-10, 18, 0), duration: 1)
        for chip in chipsInPot {
            chip.runAction(moveToPot)
        }
    }
    
    
    
    }
    
    
    
    
    
    
    


