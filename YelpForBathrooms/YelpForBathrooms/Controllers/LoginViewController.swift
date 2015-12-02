//
//  LoginViewController.swift
//  YelpForBathrooms
//
//  Created by Vince Ly on 11/21/15.
//  Copyright © 2015 Five Letter. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, GIDSignInUIDelegate, GIDSignInDelegate {
    
// MARK: - PROPERTIES
    
    @IBOutlet weak var signInButton: GIDSignInButton!
    var profileRetriever : IProfileRetriever = ProfileRetriever()
// MARK: - LIFECYCLE FUNCTIONS
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if let path = NSBundle.mainBundle().pathForResource("GoogleService-Info", ofType: "plist") {
            if let myDict = NSDictionary(contentsOfFile: path) {
                GIDSignIn.sharedInstance().clientID = myDict["CLIENT_ID"] as! String
            }
        }
        GIDSignIn.sharedInstance().signInSilently()
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
// MARK: - GIDSIGNIN DELEGATE

    func signIn(signIn: GIDSignIn!, didSignInForUser user: GIDGoogleUser!, withError error: NSError!) {
        if let err = error {
            print("Error signing in \(err)")
        } else {
            UserManager.sharedInstance.email = user.profile.email
            UserManager.sharedInstance.name = user.profile.name
            UserManager.sharedInstance.userToken = "DEMO-AUTO-AUTH"
            UserManager.sharedInstance.profileId = 1
            print("User manager shared instance:  ID: \(UserManager.sharedInstance.profileId)   Name: \(UserManager.sharedInstance.name)")
            var fullNameArr = UserManager.sharedInstance.name?.componentsSeparatedByString(" ")
            let firstName = fullNameArr![0]
            let lastName = fullNameArr![1]
            profileRetriever.authorize{ id -> Void in
                if let id = id {
                    UserManager.sharedInstance.profileId = id
                } else {
                    UserManager.sharedInstance.profileId = 1
                }
            }
            self.performSegueWithIdentifier("profileSegue", sender: self)
        }
    }
    
    
    func signIn(signIn: GIDSignIn!, didDisconnectWithUser user: GIDGoogleUser!, withError error: NSError!) {
        if let err = error {
            print("Error disconnection \(err)")
        } else {
            
        }
    }

}
