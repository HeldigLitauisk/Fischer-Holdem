//
//  NewGame.swift
//  Fischer Holdem
//
//  Created by Eimantas Urbutis on 10/03/2018.
//  Copyright © 2018 Urbut Corp. All rights reserved.
//

import Foundation
import Firebase

class NewGame {
    var db = Firestore.firestore()
    var _dispatch_group = DispatchGroup()
    var _gameId: String = "0"
    var gameId: String {
        get {
            _dispatch_group.enter()
            db.collection("games").getDocuments { (querySnapshot, err) in
                if let snapshot = querySnapshot {
                    print(snapshot.count)
                    self._gameId = String(snapshot.count + 1)
                }
            }
            _dispatch_group.leave()
            return _gameId
        }
        set {
            _gameId = newValue
        }
    }
    
    init(player1: String, player2: String) {
        db.collection("games").addDocument(data: [
            "id" : gameId,
            "player1" : player1,
            "player2" : player2 ])
    }
    
//    private func newGameId() -> Int {
//        var gamesCount = 0
//        db.collection("games").getDocuments { (querySnapshot, err) in
//            if let snapshot = querySnapshot {
//                gamesCount = snapshot.count + 1
//            }
//        }
//        return gamesCount
//    }
    
}
