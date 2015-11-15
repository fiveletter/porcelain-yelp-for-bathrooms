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
<<<<<<< HEAD
    @IBOutlet weak var backgroundWebView: UIWebView!
    
    var profileRetriever : IProfileRetriever = ProfileRetriever()
=======
    
>>>>>>> Removed .DS_Store from repository
// MARK: - LIFECYCLE FUNCTIONS
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
<<<<<<< HEAD
        //setupBackground()
=======
>>>>>>> Removed .DS_Store from repository
        
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
<<<<<<< HEAD
            UserManager.sharedInstance.userToken = user.authentication.accessToken
            UserManager.sharedInstance.refreshToken = user.authentication.refreshToken
            UserManager.sharedInstance.profileId = 1
            if user.profile.hasImage {
                if let  imageURL = user.profile.imageURLWithDimension(50), let data = NSData(contentsOfURL: imageURL), let image = UIImage(data: data)
                {
                    UserManager.sharedInstance.profilePic = image;
                }
            }
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
=======
>>>>>>> Removed .DS_Store from repository
            self.performSegueWithIdentifier("profileSegue", sender: self)
        }
    }
    
<<<<<<< HEAD
=======
    
>>>>>>> Removed .DS_Store from repository
    func signIn(signIn: GIDSignIn!, didDisconnectWithUser user: GIDGoogleUser!, withError error: NSError!) {
        if let err = error {
            print("Error disconnection \(err)")
        } else {
            
        }
    }
<<<<<<< HEAD
}

// MARK: - SETUP FUNCTIONS

extension LoginViewController{
    func setupBackground(){
        let filePath = NSBundle.mainBundle().pathForResource("giphy", ofType: ".gif")!
        print(filePath)
        let gif = NSData(contentsOfFile: filePath)
        if gif == nil{
            print("Can't find file!")
        }
        self.backgroundWebView.loadData(gif!, MIMEType: "image/gif", textEncodingName: "utf-8", baseURL: NSURL())
        self.backgroundWebView.userInteractionEnabled = false
        
        
    }
=======

>>>>>>> Removed .DS_Store from repository
}
