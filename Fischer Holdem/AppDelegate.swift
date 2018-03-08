import UIKit
import CoreData
import Firebase
import FirebaseAuthUI
import FirebaseAuth
import GoogleSignIn
import FBSDKLoginKit
import Fabric
import Crashlytics
import TwitterKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions
        launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Firebase
        FirebaseApp.configure()
        // Twitter initialization
        Twitter.sharedInstance().start(withConsumerKey:"tAVVVH3oIQre4JcuTyJ3LYKCo", consumerSecret:"4txux9SeAWSBwtUsDYdDtjNYld632fYl5cwR7yAOckQM82cutO")
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        // Google Login redirect
        let googleSignIn = GIDSignIn.sharedInstance().handle(url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplicationOpenURLOptionsKey.annotation])
        // Facebook Login redirect
        let facebookSignIn = FBSDKApplicationDelegate.sharedInstance().application(app, open: url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplicationOpenURLOptionsKey.annotation])
        // Twitter Login redirect
        let twitterSignIn = Twitter.sharedInstance().application(app, open: url, options: options)
        // Crashlytics config
        Fabric.with([Crashlytics.self, Twitter.self])
            
        return googleSignIn || facebookSignIn || twitterSignIn
    }
    
    
}
