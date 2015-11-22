//
//  ProfileViewController.swift
//  YelpForBathrooms
//
//  Created by Vince Ly on 11/18/15.
//  Copyright © 2015 Five Letter. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var logoutButton: UIButton!
    var model: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        let width = profileImageView.frame.size.width
        let height = profileImageView.frame.size.height
        print("WIDTH: \(width) \tHEIGHT: \(height)")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.hidesBarsOnTap = true
        
        print("model: \(model)")
        
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
