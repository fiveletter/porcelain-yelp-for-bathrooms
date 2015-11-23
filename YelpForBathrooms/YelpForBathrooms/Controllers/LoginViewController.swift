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
