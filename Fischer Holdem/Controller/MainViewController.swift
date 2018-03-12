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
import FirebaseAuthUI

class MainViewController: UIViewController {
    var db: Firestore!
    var currentUser: User!
    var cashier: UInt32!
    var cashierListener: ListenerRegistration!
    

    
    @IBOutlet weak var userPhoto: UIImageView!
    @IBOutlet var mainButton: UIButton!
    @IBOutlet var userName: UILabel!
    @IBAction func vsComputer(_ obj: Any) {
    }
    @IBOutlet var unknownButton: UIButton!
    @IBAction func vsHuman(_ sender: Any) {
    }
    @IBOutlet weak var cashierAmount: UILabel!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        
        // init db
        db = Firestore.firestore()
        
        // Welcomes Logged in User
        userName.text = currentUser.displayName?.uppercased() ?? "__NONAME__"
        
        // creates UIImage from user profile picture
        for profile in currentUser.providerData {
            let photoUrl = profile.photoURL
            if photoUrl != nil {
                if let data = try? Data(contentsOf: photoUrl!) {
                    userPhoto.image = UIImage(data: data)
                    userPhoto.layer.cornerRadius = userPhoto.frame.size.height / 2
                    userPhoto.layer.masksToBounds = true
                    userPhoto.layer.borderColor = UIColor.black.cgColor
                    userPhoto.layer.borderWidth = 1.0
                }
            }
        }
        // if user is new sends all his data to cloud
        checkIfNewUser()
        
      //  let newGame = NewGame(player1: "computer", player2: currentUser.uid)
        
    }
    
    @IBAction func signOut(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "LoginView") as! LoginViewController
            self.present(newViewController, animated: true, completion: nil)
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    private func addNewUser() {
        db.collection("users").document(currentUser.uid).setData( [
            "id": currentUser.uid,
            "name": currentUser.displayName ?? "__NONAME__",
            "email": currentUser.email ?? "__NOEMAIL__",
            "phone": currentUser.phoneNumber ?? "__NOPHONE__",
            "cashier": 666,
            "dateCreated" : Date()
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(self.currentUser.uid)")
            }
        }
    }
    
    private func checkIfNewUser() {
        let docRef = db.collection("users").document(currentUser.uid)
        docRef.getDocument { (document, error) in
            if let document = document {
                if document.exists {
                    print("Document data: \(String(describing: document.data()))")
                } else {
                    print("Document does not exist")
                    self.addNewUser()
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let docRef = db.collection("users").document(currentUser.uid)
        cashierListener = docRef.addSnapshotListener { (docSnapshot, err) in
            guard let docSnapshot = docSnapshot, docSnapshot.exists else { return }
            let myData = (docSnapshot.data()!["cashier"]!)
            self.cashierAmount.text = String(describing: myData) + "$"
            self.cashier = myData as! UInt32
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        cashierListener.remove()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if let nextVC = segue.destination as? GameSetupViewController {
                nextVC.cashier = cashier
                nextVC.currentUser = currentUser
            }
    }
    
    

}
