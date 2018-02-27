//
//  SharedConstants.swift
//  Fischer Holdem
//
//  Created by Eimantas Urbutis on 17/02/2018.
//  Copyright © 2018 Urbut Corp. All rights reserved.
//
let CollisionCategoryDealerButton = 5
let CollisionCategoryChip = 1
let CollisionCategoryCard = 3
let CollisionCategoryFloor = 10
let CollisionCategoryTable = 10

enum Suit: UInt32 {
    case heart = 0, daimond, club, spade
}

enum Rank: UInt32, Comparable, Equatable {
    static func <(lhs: Rank, rhs: Rank) -> Bool {
        return lhs < rhs
    }
    
    case deuce = 0, three, four, five, six, seven, eight, nine, ten, jack, queen, king, ace
}


enum ActionChoice: UInt32 {
    case fold = 0, check, bet
}

enum ReactionChoice: UInt32 {
    case fold, call, raise
}

enum GamePhase: UInt32, Hashable, Equatable {
    case preflop = 0, flop, turn, river, showdown
}





