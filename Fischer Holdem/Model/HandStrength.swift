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

    private func getHandStrength(playerCards: Array<Card>) -> (HandStrength, Rank, Rank, Rank, Rank, Rank){
        var highCard: Rank = Rank.deuce
        var secondHighCard: Rank = Rank.deuce
        var thirdHighCard: Rank = Rank.deuce
        var fourthHighCard: Rank = Rank.deuce
        var fifthHighCard: Rank = Rank.deuce
        
        var pairsCount: UInt32 = 0
        var pairRank: Rank = Rank.deuce
        var secondPairRank: Rank = Rank.deuce
        var tripsCount: UInt32 = 0
        var tripsRank: Rank = Rank.deuce
        var fourOfAKindCount: UInt32 = 0
        var fourOfAKindRank: Rank = Rank.deuce
        var fiveOfAKindCount: UInt32 = 0
        var fiveOfAKindRank: Rank = Rank.deuce
        var previousValue: UInt32 = 0
        var count = 0
        let sortedCards = playerCards.sorted(by: { $0.cardValue.rank < $1.cardValue.rank })
        
        
        for card in sortedCards {
            if card.cardValue.rank.rawValue - previousValue == 0 {
               count += 1
                if count == 4 {
                    fiveOfAKindRank = card.cardValue.rank
                    fiveOfAKindCount += 1
                } else if count == 3 {
                    fourOfAKindRank = card.cardValue.rank
                    fourOfAKindCount += 1
                    if highCard < pairRank {
                        highCard = pairRank
                    }
                } else if count == 2 {
                    
                    tripsCount += 1
                    pairsCount -= 1
                    print("plaers counts")
                    print(pairsCount)
                    print(tripsCount)
                    if pairsCount >= 1 {
                        pairRank = secondPairRank
                    }
                    if tripsCount == 2 {
                        tripsCount -= 1
                        pairRank = tripsRank
                        }
                    tripsRank = card.cardValue.rank
                } else if count == 1 {
                    pairsCount += 1
                    print("pairs count")
                    print(pairsCount)
                        if pairsCount == 2 {
                        secondPairRank = pairRank
                        } else if pairsCount == 3 {
                        pairsCount -= 1
                        if secondPairRank > highCard {
                            highCard = secondPairRank
                        }
                        secondPairRank = pairRank
                    }
                    pairRank = card.cardValue.rank
                }
            } else {
                fifthHighCard = fourthHighCard
                fourthHighCard = thirdHighCard
                thirdHighCard = secondHighCard
                secondHighCard = highCard
                highCard = card.cardValue.rank
                count = 0
            }
            previousValue = card.cardValue.rank.rawValue
            //sortedCards.remove(at: 0)
        }
        
        if fiveOfAKindCount == 1 {
            return (HandStrength.fiveOfAKind, fiveOfAKindRank, Rank.deuce, Rank.deuce, Rank.deuce, Rank.deuce)
        } else if fourOfAKindCount == 1 {
            return (HandStrength.fourOfAKind, fourOfAKindRank, highCard, Rank.deuce, Rank.deuce, Rank.deuce)
        } else if tripsCount == 1 && pairsCount >= 1 {
            return (HandStrength.fullHouse, tripsRank, pairRank, Rank.deuce, Rank.deuce, Rank.deuce)
        } else if checkFlush(playerCards: playerCards).0 {
            let flush = checkFlush(playerCards: playerCards)
            return (HandStrength.flush, flush.1, flush.2, flush.3, flush.4, flush.5)
        } else if checkStraight(playerCards: playerCards).0 {
            return (HandStrength.straight, checkStraight(playerCards: playerCards).1, Rank.deuce, Rank.deuce, Rank.deuce, Rank.deuce )
        } else if  tripsCount == 1 {
            return (HandStrength.trips, tripsRank, highCard, secondHighCard, Rank.deuce, Rank.deuce)
        } else if pairsCount == 2 {
            return (HandStrength.twoPairs, pairRank, secondPairRank, highCard, Rank.deuce, Rank.deuce)
        } else if pairsCount == 1 {
            return (HandStrength.pair, pairRank, highCard, secondHighCard, thirdHighCard, Rank.deuce)
        } else {
            return (HandStrength.highCard, highCard, secondHighCard, thirdHighCard, fourthHighCard, fifthHighCard)
        }
    }
    
    private func checkStraight(playerCards: Array<Card>) -> (Bool, Rank) {
        let withoutDuplicates = playerCards.filterDuplicates { $0.cardValue.rank == $1.cardValue.rank }
        let sortedCards = withoutDuplicates.sorted(by: { $0.cardValue.rank < $1.cardValue.rank })
        var rowCount = 0
        var highestCard: Card = Card(cardValue: (Rank.deuce, Suit.club))
        var previousValue: UInt32 = sortedCards.first!.cardValue.rank.rawValue
        
        if sortedCards.last?.cardValue.rank == Rank.ace && sortedCards.first?.cardValue.rank == Rank.deuce {
            previousValue = 0
        }
        
        for card in sortedCards {
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
        
        if rowCount >= 4 {
            return (true, highestCard.cardValue.rank)
        } else  { return (false, highestCard.cardValue.rank)
        }
    }
    
    
    private func checkFlush(playerCards: Array<Card> ) -> (Bool, Rank, Rank, Rank, Rank, Rank) {
        let clubs = playerCards.filter({ $0.cardValue.suit == Suit.club }).sorted(by: { $0.cardValue.rank < $1.cardValue.rank }).suffix(5)
        let hearts = playerCards.filter({ $0.cardValue.suit == Suit.heart }).sorted(by: { $0.cardValue.rank < $1.cardValue.rank }).suffix(5)
        let diamonds = playerCards.filter({ $0.cardValue.suit == Suit.daimond }).sorted(by: { $0.cardValue.rank < $1.cardValue.rank }).suffix(5)
        let spades = playerCards.filter({ $0.cardValue.suit == Suit.spade }).sorted(by: { $0.cardValue.rank < $1.cardValue.rank }).suffix(5)
        
        if clubs.count >= 5 {
            return (true, clubs[4].cardValue.rank, clubs[3].cardValue.rank, clubs[2].cardValue.rank, clubs[1].cardValue.rank, clubs[0].cardValue.rank)
        } else if hearts.count >= 5 {
            return (true, hearts[4].cardValue.rank, hearts[3].cardValue.rank, hearts[2].cardValue.rank, hearts[1].cardValue.rank, hearts[0].cardValue.rank)
        } else if diamonds.count >= 5 {
            return (true, diamonds[4].cardValue.rank, diamonds[3].cardValue.rank, diamonds[2].cardValue.rank, diamonds[1].cardValue.rank, clubs[0].cardValue.rank)
        } else if spades.count >= 5 {
            return (true, spades[4].cardValue.rank, spades[3].cardValue.rank, spades[2].cardValue.rank, spades[1].cardValue.rank, spades[0].cardValue.rank)
        } else {
            return (false, Rank.deuce, Rank.deuce, Rank.deuce, Rank.deuce, Rank.deuce)
        }
    }
    
    private mutating func determineWinner() {
        let player1HandStrength = getHandStrength(playerCards: player1Cards)
        let player2HandStrength = getHandStrength(playerCards: player2Cards)
        
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
