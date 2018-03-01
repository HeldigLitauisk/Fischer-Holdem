//
//  Deck.swift
//  Fischer Holdem
//
//  Created by Eimantas Urbutis on 18/02/2018.
//  Copyright © 2018 Urbut Corp. All rights reserved.
//

import Foundation
import SceneKit

class Deck: SCNNode {
    var deck: Array<Card> = []
    
    override init() {
        super.init()
        self.name = "deck"
        self.deck = deckBuilder()
        createCards()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func deckBuilder() -> Array<Card> {
        var newDeck: Array<Card> = []
        for card in 1...52 {
            let randomRank = Rank(rawValue: arc4random_uniform(13) + 1)
            let randomSuit = Suit(rawValue: arc4random_uniform(4))
            let cardNode = Card(cardValue: (randomRank!, randomSuit!))
            cardNode.name = String(card)
            newDeck.append(cardNode)
        }
      return newDeck
    }
    
    private func createCards() {
        for card in deck {
            card.colorizeCard()
            card.position = SCNVector3(x: 15, y: 18, z: 0)
            self.addChildNode(card)
        }
    }
    
    func dealCard() -> Card {
        let cardNode = deck[deck.count - 1]
        deck.remove(at: deck.count - 1)
        return cardNode
    }
    
}
