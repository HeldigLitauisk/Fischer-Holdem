//
//  SharedConstants.swift
//  Fischer Holdem
//
//  Created by Eimantas Urbutis on 17/02/2018.
//  Copyright © 2018 Urbut Corp. All rights reserved.
//
let CollisionCategoryDealerButton = 4
let CollisionCategoryChip = 6
let CollisionCategoryCard = 8
let CollisionCategoryFloor = 10

enum Suit: Int {
    case heart = 0, daimond, club, spade
}

enum Rank: Int {
    case deuce = 0, three, four, five, six, seven, eight, nine, ten, jack, queen, king, ace
}
