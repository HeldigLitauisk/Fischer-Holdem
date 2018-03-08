import UIKit
import Firebase
import FirebaseAuth
import FirebaseAuthUI
import FirebaseDatabaseUI
import FirebaseGoogleAuthUI
import FirebaseFacebookAuthUI
import FirebaseTwitterAuthUI
import FBSDKCoreKit
import FBSDKLoginKit

class LoginViewController: UIViewController, FUIAuthDelegate {
    
    var kFacebookAppID = "111111111111111"
    override func viewDidLoad() {
        super.viewDidLoad()
        checkLoggedIn()
    }
    
    func checkLoggedIn() {
        Auth.auth().addStateDidChangeListener { auth, user in
            if user != nil {
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let newViewController = storyBoard.instantiateViewController(withIdentifier: "Game Options") as! testViewController
                self.present(newViewController, animated: true, completion: nil)
            } else {
                // No user is signed in.
                self.login()
            }
        }
    }
    
    func login() {
        let authUI = FUIAuth.defaultAuthUI()
        let facebookProvider = FUIFacebookAuth()
        let googleProvider = FUIGoogleAuth()
        let twitterProvider = FUITwitterAuth()
        authUI?.delegate = self
        authUI?.providers = [googleProvider, facebookProvider, twitterProvider]
        let authViewController = authUI?.authViewController()
        self.present(authViewController!, animated: true, completion: nil)
    }
    
    @IBAction func signOut(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    func authUI(_ authUI: FUIAuth, didSignInWith user: User?, error: Error?) {
        if error != nil {
            //Problem signing in
            login()
            
        }else {
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "Game Options") as! testViewController
            self.present(newViewController, animated: true, completion: nil)
            }
        }
    
    }

