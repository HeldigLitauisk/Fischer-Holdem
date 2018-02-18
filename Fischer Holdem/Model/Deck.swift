//
//  Deck.swift
//  Fischer Holdem
//
//  Created by Eimantas Urbutis on 18/02/2018.
//  Copyright © 2018 Urbut Corp. All rights reserved.
//

import Foundation
import SceneKit

class Deck {
    private var deck = deckBuilder()

    private static func deckBuilder() -> Array<(rank: Rank, suit: Suit)> {
        var deck: Array<(rank: Rank, suit: Suit)> = []
        for _ in 1...52 {
            let randomRank = Rank(rawValue: Int(arc4random_uniform(13)))
            let randomSuit = Suit(rawValue: Int(arc4random_uniform(4)))
            deck.append((rank: randomRank!, suit: randomSuit!))
        }
        return deck
    }
    
    func dealCard() -> Card {
        let randomCard = Int(arc4random_uniform(UInt32(deck.count)))
        let cardNode = Card(cardValue: deck[randomCard])
        deck.remove(at: randomCard)
        return cardNode
    }
}
