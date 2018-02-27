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
    
    func checkFlush(playerCards: Array<Card> ) -> (Bool, Rank) {
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
        let sortedCards = playerCards.sorted { $0.cardValue.rank < $1.cardValue.rank }
        return (false, Rank.deuce)
    }
 
    func checkFlush2(playerCards: Array<Card> ) -> (Bool, Rank) {
        if playerCards.filter({ $0.cardValue.suit == Suit.club }).count >= 5 {
            return (true, (playerCards.filter({ $0.cardValue.suit == Suit.club }).sorted { $0.cardValue.rank < $1.cardValue.rank }.last?.cardValue.rank)!)
        } else if playerCards.filter({ $0.cardValue.suit == Suit.daimond }).count >= 5 {
            return (true, (playerCards.filter({ $0.cardValue.suit == Suit.daimond }).sorted { $0.cardValue.rank < $1.cardValue.rank }.last?.cardValue.rank)!)
            } else if playerCards.filter({ $0.cardValue.suit == Suit.heart }).count >= 5 {
            return (true, (playerCards.filter({ $0.cardValue.suit == Suit.heart }).sorted { $0.cardValue.rank < $1.cardValue.rank }.last?.cardValue.rank)!)
                } else if playerCards.filter({ $0.cardValue.suit == Suit.spade }).count >= 5 {
            return (true, (playerCards.filter({ $0.cardValue.suit == Suit.spade }).sorted { $0.cardValue.rank < $1.cardValue.rank }.last?.cardValue.rank)!)
        } else {
            return (false, Rank.deuce)
        }
    }

    
 //   static func evaluateHands() -> Player {
    //}
    
    
}
