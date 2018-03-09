//
//  GameSetupViewController.swift
//  Fischer Holdem
//
//  Created by Eimantas Urbutis on 08/03/2018.
//  Copyright © 2018 Urbut Corp. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class GameSetupViewController: UIViewController {
    
    var db: Firestore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        // [END setup]
        db = Firestore.firestore()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
   // @IBAction func didTouchSmokeTestButton(_ sender: AnyObject) {
    private func addNewUsers() {
      //  addAdaLovelace()
    //    addAlanTuring()
        db.collection("dsd")
        
    }
    
        // Quickstart
      //  addAdaLovelace()
     //   addAlanTuring()
  //      getCollection()
   //     listenForUsers()
    
    private func addAdaLovelace() {
        // [START add_ada_lovelace]
        // Add a new document with a generated ID
        var ref: DocumentReference? = nil
        ref = db.collection("users").addDocument(data: [
            "first": "Ada",
            "last": "Lovelace",
            "born": 1815
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
            }
        }
        // [END add_ada_lovelace]
    }
    
    private func addAlanTuring() {
        var ref: DocumentReference? = nil
        
        // [START add_alan_turing]
        // Add a second document with a generated ID.
        ref = db.collection("users").addDocument(data: [
            "first": "Alan",
            "middle": "Mathison",
            "last": "Turing",
            "born": 1912
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
            }
        }
        // [END add_alan_turing]
    }
    
}
