//
//  ProfileViewController.swift
//  YelpForBathrooms
//
//  Created by Vince Ly on 11/18/15.
//  Copyright © 2015 Five Letter. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
// MARK: - PROPERTIES

    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var dislikesLabel: UILabel!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var numOfDislikesLabel: UILabel!
    @IBOutlet weak var numOfLikesLabel: UILabel!
    @IBOutlet weak var numOfReviewsLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var reviewLabel: UILabel!
    var model: Int = 0

// MARK: - LIFECYCLE FUNCTIONS
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set label strings
        nameLabel.text = UserManager.sharedInstance.name?.componentsSeparatedByString(" ")[0].capitalizedString
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = true
        
        // Label style
        setTextColorOfView(UIColor.whiteColor())

        // Background style
        backgroundImageView.layer.backgroundColor = UIColor.colorFromHexRGBValue(0x233046).CGColor
        
        // Button style
        logoutButton.layer.cornerRadius = profileImageView.frame.size.width/10
        logoutButton.backgroundColor = UIColor.colorFromHexRGBValue(0x15A8A7)
        
        // Round image view
        profileImageView.layer.cornerRadius = profileImageView.frame.size.width/2
        profileImageView.clipsToBounds = true
        profileImageView.layer.borderWidth = 3.0
        profileImageView.layer.borderColor = UIColor.colorFromHexRGBValue(0x16ADA7).CGColor
    }
    
// MARK: - VIEW CONTROLLER

    @IBAction func logOut() {
        GIDSignIn.sharedInstance().signOut()
        self.navigationController?.popToRootViewControllerAnimated(true)
        UserManager.sharedInstance.logOut()
    }
    // MARK: - STYLE
    
    func setTextColorOfView(color: UIColor){
        nameLabel.textColor = color
        numOfReviewsLabel.textColor = color
        numOfLikesLabel.textColor = color
        numOfDislikesLabel.textColor = color
        reviewLabel.textColor = color
        likesLabel.textColor = color
        dislikesLabel.textColor = color
        logoutButton.titleLabel?.textColor = color
    }
    
}
