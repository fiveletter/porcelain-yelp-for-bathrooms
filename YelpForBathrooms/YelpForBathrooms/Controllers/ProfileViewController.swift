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
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!

// MARK: - LIFECYCLE FUNCTIONS
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set label strings
        nameLabel.text = UserManager.sharedInstance.name?.componentsSeparatedByString(" ")[0].capitalizedString
        //let tapGesture = UITapGestureRecognizer()
        //tapGesture.addTarget(self, action: "profilePicTapped")
        //profileImageView.addGestureRecognizer(tapGesture)
        if let image = UserManager.sharedInstance.profilePic {
            profileImageView.image = image
        } else {
            profileImageView.image = UIImage(named: "Doge")
        }
    }
    
    @IBAction func profilePicTapped(){
        let ac = UIAlertController(title: "Choose Image", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        ac.addAction(UIAlertAction(title: "Gallery", style: .Default, handler: choosePhoto))
        ac.addAction(UIAlertAction(title: "Camera", style: .Default, handler: newPhoto))
        ac.addAction(UIAlertAction(title: "Close", style: .Default, handler: nil))
        presentViewController(ac, animated: true, completion: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = false
        
        // Label style
        setTextColorOfView(UIColor.blackColor())

        // Background style
        //backgroundImageView.layer.backgroundColor = UIColor.colorFromHexRGBValue(0x233046).CGColor
        
        // Button style
        logoutButton.layer.cornerRadius = profileImageView.frame.size.width/10
        logoutButton.backgroundColor = UIColor.colorFromHexRGBValue(0x26C27F)
        
        // Round image view
        profileImageView.layer.cornerRadius = profileImageView.frame.size.width/2
        profileImageView.clipsToBounds = true
        profileImageView.layer.borderWidth = 3.0
        profileImageView.layer.borderColor = UIColor.colorFromHexRGBValue(0x26C27F).CGColor
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
        logoutButton.titleLabel?.textColor = color
    }
    
}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        picker.dismissViewControllerAnimated(true, completion: nil)
        let profileImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        profileImageView.image = profileImage
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func choosePhoto(action: UIAlertAction!){
        let picker = UIImagePickerController()
        picker.delegate = self
        if UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary) {
            picker.sourceType = .PhotoLibrary
            presentViewController(picker, animated: true, completion: nil)
        }
    }
    
    func newPhoto(action: UIAlertAction!){
        let picker = UIImagePickerController()
        picker.delegate = self
        if UIImagePickerController.isSourceTypeAvailable(.Camera) {
            picker.sourceType = .Camera
            presentViewController(picker, animated: true, completion: nil)
        }
    }
}