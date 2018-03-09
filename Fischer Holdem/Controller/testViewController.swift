//
//  testViewController.swift
//  Fischer Holdem
//
//  Created by Eimantas Urbutis on 21/02/2018.
//  Copyright © 2018 Urbut Corp. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseAuth

class testViewController: UIViewController {
    var db: Firestore!
    var currentUser: User!
    

    @IBOutlet weak var userPhoto: UIImageView!
    @IBOutlet var cmdLogin: UIButton!
    @IBOutlet var lblMyName: UILabel!
    @IBAction func btnClick(_ obj: Any) {
        
        
    }
    @IBOutlet var crachButton: UIButton!
    @IBAction func crashAction(_ sender: Any) {
        //      getCollection()
        //     listenForUsers()
    }
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        
        // [END setup]
        db = Firestore.firestore()
        
        // Welcomes Logged in User
        lblMyName.text = "WELCOME, " + (currentUser.displayName?.uppercased())!
        for profile in currentUser.providerData {
            let photoUrl = profile.photoURL //SMALL IMAGE
            if let data = try? Data(contentsOf: photoUrl!)
            {
                userPhoto.image = UIImage(data: data)
            }
        }
        
    }
    
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

    private func getCollection() {
        // [START get_collection]
        db.collection("users").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                }
            }
        }
        // [END get_collection]
    }
    
    private func listenForUsers() {
        // [START listen_for_users]
        // Listen to a query on a collection.
        //
        // We will get a first snapshot with the initial results and a new
        // snapshot each time there is a change in the results.
        db.collection("users")
            .whereField("born", isLessThan: 1900)
            .addSnapshotListener { querySnapshot, error in
                guard let snapshot = querySnapshot else {
                    print("Error retreiving snapshots \(error!)")
                    return
                }
                print("Current users born before 1900: \(snapshot.documents.map { $0.data() })")
        }
        // [END listen_for_users]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   
    
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
