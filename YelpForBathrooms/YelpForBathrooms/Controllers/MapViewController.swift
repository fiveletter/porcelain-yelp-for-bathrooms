//
//  MapViewController.swift
//  YelpForBathrooms
//
//  Created by Vince Ly on 11/21/15.
//  Copyright © 2015 Five Letter. All rights reserved.
//

import UIKit

class MapViewController: UIViewController {
    
    var logged_in = true
    var model: Int = 1219
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func openProfileScreen() {
        
        if UserManager.sharedInstance.IsSignedIn {
            self.performSegueWithIdentifier("profileSegue", sender: self)
        }
        else
        {
            self.performSegueWithIdentifier("loginSegue", sender: self)
        }
    }
    @IBAction func addBathroom() {
        
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let segueIdentifier = segue.identifier{
            switch segueIdentifier{
            case "profileSegue":
                let profileViewController = segue.destinationViewController as! ProfileViewController
                profileViewController.model = model;
            case "loginSegue":
                let loginViewController = segue.destinationViewController as! LoginViewController
                
            default:
                print("NO OP")
            }
        }
    }


}
