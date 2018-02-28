//
//  HandStrength.swift
//  Fischer Holdem
//
//  Created by Eimantas Urbutis on 27/02/2018.
//  Copyright © 2018 Urbut Corp. All rights reserved.
//

import Foundation

struct HandStrength {
    let player1: Player
    let player2: Player
    var player1Cards: Array<Card>
    var player2Cards: Array<Card>
    var isSplit: Bool = false
    var winner: Player?
    var winnerHandStrength: HandStrength?
    var winnerHandRank: Rank?
    
    init(player1: Player, player2: Player, board: Array<Card>) {
        self.player1 = player1
        self.player2 = player2
        self.player1Cards = board
        player1Cards.append(player1.playerHand!.0)
        player1Cards.append(player1.playerHand!.1)
        self.player2Cards = board
        player2Cards.append(player2.playerHand!.0)
        player2Cards.append(player2.playerHand!.1)
        determineWinner()
    }
    
    enum HandStrength: UInt32, Comparable {
        static func <(lhs: HandStrength, rhs: HandStrength) -> Bool {
            return lhs.rawValue < rhs.rawValue
        }
        case highCard, pair, twoPairs, trips, straight, flush, fullHouse, fourOfAKind, straightFlush, fiveOfAKind
    }
    
    private func checkStraight(playerCards: Array<Card>) -> (Bool, Rank) {
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
                if rowCount < 5 {
                    rowCount = 0
                }
            }
            previousValue = card.cardValue.rank.rawValue
        }
        if rowCount >= 5 {
            return (true, highestCard.cardValue.rank)
        } else  { return (false, highestCard.cardValue.rank)
        }
    }
    
    private func checkFlush(playerCards: Array<Card> ) -> (Bool, Rank) {
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
    
    private func evaluateHand(playerCards: Array<Card>) -> (HandStrength, Rank, Rank) {
        var playerCards = playerCards
        var highestFiveOfAKind = Rank.deuce
        var highestFourOfAKind = Rank.deuce
        var highestTrips = Rank.deuce
        var secondHighestTrips = Rank.deuce
        var highestPair = Rank.deuce
        var secondHighestPair = Rank.deuce
        var highCard = Rank.deuce
        var secondHighCard = Rank.deuce
        var numberOfPairs = 0
        var numberOfTrips = 0
        var numberOfFourOfAKind = 0
        var numberOfFiveOfAKind = 0
        
        for card in playerCards {
            var repeats = 0
            if highCard < card.cardValue.rank {
                secondHighCard = highCard
                highCard = card.cardValue.rank
            }
            for card2 in playerCards {
                if card.cardValue.rank == card2.cardValue.rank {
                    repeats += 1
                    if repeats == 2 {
                        numberOfPairs += 1
                        if card.cardValue.rank > highestPair {
                            secondHighestPair = highestPair
                            highestPair = card.cardValue.rank
                        }
                    } else if repeats == 3 {
                        numberOfPairs -= 1
                        numberOfTrips += 1
                        if card.cardValue.rank > highestTrips {
                            secondHighestTrips = highestTrips
                            highestTrips = card.cardValue.rank
                        }
                        if card.cardValue.rank == highestPair {
                            highestPair = secondHighestPair
                        }
                    } else if repeats == 4 {
                        numberOfFourOfAKind += 1
                        highestFourOfAKind = card.cardValue.rank
                    } else if repeats == 5 {
                        numberOfFiveOfAKind += 1
                        highestFiveOfAKind = card.cardValue.rank
                    }
                }
            }
            playerCards.remove(at: 0)
        }
        if numberOfFiveOfAKind == 1 {
            return (HandStrength.fiveOfAKind, highestFiveOfAKind, highCard)
        } else if numberOfFourOfAKind == 1 {
            if highestFiveOfAKind == highCard {
                highCard = secondHighCard
            }
            return (HandStrength.fourOfAKind, highestFourOfAKind, highCard)
        } else if numberOfTrips >= 1 && numberOfPairs >= 1 {
            if secondHighestTrips > highestPair {
                highestPair = secondHighestTrips
            }
            return (HandStrength.fullHouse, highestTrips, highestPair)
        } else if checkFlush(playerCards: playerCards).0 {
            return (HandStrength.flush, checkFlush(playerCards: playerCards).1, highCard)
        } else if checkStraight(playerCards: playerCards).0 {
            return (HandStrength.straight, checkStraight(playerCards: playerCards).1, highCard)
        } else if numberOfTrips >= 1 {
            if highestTrips == highCard {
                highCard = secondHighCard
            }
            return (HandStrength.trips, highestTrips, highCard)
        } else if numberOfPairs >= 2 {
            if highestPair == highCard {
                highCard = secondHighCard
            }
            // not covering cases where both players have equal two pairs but different high card
            return (HandStrength.twoPairs, highestPair, secondHighestPair)
        } else if numberOfPairs == 1 {
            if highestPair == highCard {
                highCard = secondHighCard
            }
            return (HandStrength.pair, highestPair, highCard)
        } else {
            return (HandStrength.highCard, highCard, secondHighCard)
        }
    }
    
    private mutating func determineWinner() {
        let player1HandStrength = evaluateHand(playerCards: player1Cards)
        let player2HandStrength = evaluateHand(playerCards: player2Cards)
        
        if player1HandStrength > player2HandStrength {
            winner = player1
            winnerHandStrength = player1HandStrength.0
            winnerHandRank = player1HandStrength.1
        } else if player1HandStrength < player2HandStrength {
            winner = player2
            winnerHandStrength = player2HandStrength.0
            winnerHandRank = player2HandStrength.1
        } else if player1HandStrength == player2HandStrength  {
            isSplit = true
        }
    }
        
    
 } // END

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
