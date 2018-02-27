//
//  HandStrength.swift
//  Fischer Holdem
//
//  Created by Eimantas Urbutis on 27/02/2018.
//  Copyright © 2018 Urbut Corp. All rights reserved.
//

import Foundation

struct HandStrength {
    var player1Cards: Array<Card>
    var player2Cards: Array<Card>
    var isSplit: Bool = false
    var winner: Player?
    
    init(player1: Player, player2: Player, board: Array<Card>) {
        self.player1Cards = board
        player1Cards.append(player1.playerHand!.0)
        player1Cards.append(player1.playerHand!.1)
        self.player2Cards = board
        player2Cards.append(player2.playerHand!.0)
        player2Cards.append(player2.playerHand!.1)
    }
    
    enum HandStrength: UInt32, Comparable {
        static func <(lhs: HandStrength, rhs: HandStrength) -> Bool {
            return lhs.rawValue < rhs.rawValue
        }
        case highCard, pair, twoPairs, trips, straight, flush, fourOfAKing, straightFlush
    }
    
    func checkFlushLongMethod(playerCards: Array<Card> ) -> (Bool, Rank) {
        var numberOfSpades = 0
        var numberOfClubs = 0
        var numberOfHearts = 0
        var numberOfDaimonds = 0
        var highestSpade = Rank.deuce
        var highestClub = Rank.deuce
        var highestHeart = Rank.deuce
        var highestDaimond = Rank.deuce
        
        for card in playerCards {
            switch card.cardValue.suit {
            case .club:
                numberOfClubs += 1
                if card.cardValue.rank > highestClub {
                    highestClub = card.cardValue.rank
                }
                if numberOfClubs == 5 {
                    return (true, highestClub)
                }
            case .daimond:
                numberOfDaimonds += 1
                if card.cardValue.rank > highestDaimond {
                    highestDaimond = card.cardValue.rank
                }
                if numberOfClubs == 5 {
                    return (true, highestDaimond)
                }
            case .heart:
                numberOfHearts += 1
                if card.cardValue.rank > highestHeart {
                    highestHeart = card.cardValue.rank
                }
                if numberOfClubs == 5 {
                    return (true, highestHeart)
                }
            case .spade:
                numberOfSpades += 1
                if card.cardValue.rank > highestSpade {
                    highestSpade = card.cardValue.rank
                }
                if numberOfClubs == 5 {
                    return (true, highestSpade)
                }
            }
        }
        return (false, highestSpade)
    }
    
    func checkStraight(playerCards: Array<Card>) -> (Bool, Rank) {
        let sortedCards = playerCards.sorted(by: { $0.cardValue.rank < $1.cardValue.rank })
        let withoutDuplicates = sortedCards.filterDuplicates { $0.cardValue.rank == $1.cardValue.rank }
        var rowCount: UInt32 = 0
        var previousValue: UInt32 = 0
        var highestCard: Card = Card(cardValue: (Rank.deuce, Suit.club))
        for card in withoutDuplicates {
            if card.cardValue.rank.rawValue - previousValue == 1 {
                rowCount += 1
                highestCard = card
            } else {
                if rowCount >= 5 {
                    return (true, highestCard.cardValue.rank)
                }
                rowCount = 0
            }
            previousValue = card.cardValue.rank.rawValue
        }
        if rowCount >= 5 {
            return (true, highestCard.cardValue.rank)
        } else  { return (false, highestCard.cardValue.rank)
        }
    }
        
   
 
    func checkFlush(playerCards: Array<Card> ) -> (Bool, Rank) {
        let clubs = playerCards.filter({ $0.cardValue.suit == Suit.club }).sorted { $0.cardValue.rank < $1.cardValue.rank }
        let hearts = playerCards.filter({ $0.cardValue.suit == Suit.heart }).sorted { $0.cardValue.rank < $1.cardValue.rank }
        let diamonds = playerCards.filter({ $0.cardValue.suit == Suit.daimond }).sorted { $0.cardValue.rank < $1.cardValue.rank }
        let spades = playerCards.filter({ $0.cardValue.suit == Suit.spade }).sorted { $0.cardValue.rank < $1.cardValue.rank }
        
        if clubs.count >= 5 {
            return (true, clubs.last!.cardValue.rank)
        } else if hearts.count >= 5 {
            return (true, hearts.last!.cardValue.rank)
        } else if diamonds.count >= 5 {
            return (true, diamonds.last!.cardValue.rank)
        } else if spades.count >= 5 {
            return (true, spades.last!.cardValue.rank)
        } else {
            return (false, Rank.deuce)
        }
    }

    
 //   static func evaluateHands() -> Player {
    //}
    
    
 }

extension Array {
    
    func filterDuplicates(includeElement: @escaping (_ lhs:Element, _ rhs:Element) -> Bool) -> [Element]{
        var results = [Element]()
        
        forEach { (element) in
            let existingElements = results.filter {
                return includeElement(element, $0)
            }
            if existingElements.count == 0 {
                results.append(element)
            }
        }
        return results
    }
}
