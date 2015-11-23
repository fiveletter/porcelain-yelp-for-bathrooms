//
//  ProfileViewController.swift
//  YelpForBathrooms
//
//  Created by Vince Ly on 11/18/15.
//  Copyright © 2015 Five Letter. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    // ImageViews
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    // Buttons
    @IBOutlet weak var logoutButton: UIButton!
    
    // Labels
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var numOfReviewsLabel: UILabel!
    @IBOutlet weak var numOfLikesLabel: UILabel!
    @IBOutlet weak var numOfDislikesLabel: UILabel!
    @IBOutlet weak var reviewLabel: UILabel!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var dislikesLabel: UILabel!
    
    // Controller Variables
    var model: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        let width = profileImageView.frame.size.width
        let height = profileImageView.frame.size.height
        print("WIDTH: \(width) \tHEIGHT: \(height)")
        
        // Set label strings
        nameLabel.text = "FIVE LETTER FIVE"
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setTextColorOfView(color: UIColor){
        nameLabel.textColor = color
        numOfReviewsLabel.textColor = color
        numOfLikesLabel.textColor = color
        numOfDislikesLabel.textColor = color
        reviewLabel.textColor = color
        likesLabel.textColor = color
        dislikesLabel.textColor = color
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
