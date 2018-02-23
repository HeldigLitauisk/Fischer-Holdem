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

enum Rank: UInt32 {
    case deuce = 0, three, four, five, six, seven, eight, nine, ten, jack, queen, king, ace
}

enum Choice: UInt32 {
    // fold ; check/call ; raise/bet accordingly
    case red = 0, blue, green
}

enum ActionChoice: UInt32 {
    case fold = 0, check, bet
}

enum Reaction: UInt32 {
    case fold = 0, call, raise
}

enum GamePhase: String {
    case preflop, flop, turn, river, showdown
}





