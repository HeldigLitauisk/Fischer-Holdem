//
//  RoundView.swift
//  Fischer Holdem
//
//  Created by Eimantas Urbutis on 18/02/2018.
//  Copyright © 2018 Urbut Corp. All rights reserved.
//

/*import Foundation
import SceneKit

struct RoundView {
 
    init(phase: GamePhase) {
        
        switch phase {
            case .preflop:
                preflopActions()
            case .flop:
                flopActions()
            case .turn:
                turnActions()
            case .river:
                riverActions()
            case .showdown:
                showdownActions()
        }
    }
    
    
    
    private func preflopActions() {
    }
    
    private func flopActions() {
        let heroCard1 = Deck.dealCard()
        let opponentCard1 = Deck.dealCard()
        let heroCard2 = Deck.dealCard()
        let opponentCard2 = Deck.dealCard()
    }
    
    private func turnActions() {
    }
    
    private func riverActions() {
    }
    
    private func showdownActions() {
    }
    
    func dealCards(gamePhase: GamePhase) -> [Card] {
        var cardNodes: [Card]?
        switch gamePhase {
        case .preflop:
            let heroCard1 = deck.assignCard()
            let opponentCard1 = deck.assignCard()
            let heroCard2 = deck.assignCard()
            let opponentCard2 = deck.assignCard()
            heroCard1.name = "hero"
            heroCard2.name = "hero"
            opponentCard1.name = "opponent"
            opponentCard2.name = "opponent"
            heroCard1.position = SCNVector3(10, 18, 0)
            opponentCard1.position = SCNVector3(10, 18, 0)
            heroCard2.position = SCNVector3(10, 18, 0)
            opponentCard2.position = SCNVector3(10, 18, 0)
            cardNodes = [heroCard1, opponentCard1, heroCard2, opponentCard2]
            return cardNodes!
        default:
            return cardNodes!
        }
    }
    
} */
