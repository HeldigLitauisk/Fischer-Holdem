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
    var gameId: String = "__NODATA__"
    var player1: String
    var player2: String
    
    init(player1: String, player2: String) {
        self.player1 = player1
        self.player2 = player2
        newGameId {
            self.addGameData()
        }
    }
        
    
    private func newGameId(onSccess completion:@escaping () -> Void) {
        let _dispatch_group = DispatchGroup()
        _dispatch_group.enter()
        db.collection("games").getDocuments { (querySnapshot, err) in
            if let snapshot = querySnapshot {
                self.gameId = String(snapshot.count + 1)
                _dispatch_group.leave()
            }
        }

        _dispatch_group.notify(queue: DispatchQueue.main, execute: {
            completion()
        })
    }
    
    private func addGameData() {
        
        db.collection("games").document(gameId).setData( [
            "id" : gameId,
            "player1" : player1,
            "player2" : player2,
            "startedAt" : Date()
            ])
    }
    
}
