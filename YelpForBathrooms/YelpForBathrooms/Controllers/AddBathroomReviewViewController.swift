//
<<<<<<< HEAD
//  AddBathroomViewController.swift
=======
//  AddBathroomReviewViewController.swift
>>>>>>> Removed .DS_Store from repository
//  YelpForBathrooms
//
//  Created by Vince Ly on 11/21/15.
//  Copyright © 2015 Five Letter. All rights reserved.
//

import UIKit
<<<<<<< HEAD
import GoogleMaps

class AddBathroomReviewViewController: UIViewController {
    
    // MARK: - PROPERTIES
    
    @IBOutlet weak var ratingView: RatingView?
    @IBOutlet weak var frameView: UIView?
    @IBOutlet weak var backgroundView: UIView?
    @IBOutlet weak var divider: UIView?
    @IBOutlet weak var reviewTextArea: UITextView?
    @IBOutlet weak var imageChooserButton: ImageChooserButton?
    
    var flagStatusDict = ["Non existing": false, "Hard to find": false, "Paid": false, "Public": false]
    var reviewWriter: IReviewWriter = ReviewWriter()
    var bathroom: Bathroom!
    
    // MARK: - LIFECYCLE FUNCTIONS
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(bathroom.title)
        
        //Setup functions
        setupNavigationBar()
        setupRatingView()
        setupGestureRecognizer()
        setupReviewTextView()
        
        // Delegates
        reviewTextArea?.delegate = self
        imageChooserButton?.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // Styling functions
        styleNavigationBar()
        styleBackgroundView()
        styleFrameView()
        styleDivider()
        styleReviewTextView()
        styleImageChooserButton()
    }
    
    // MARK: - IBACTION FUNCTIONS
    @IBAction func flagTapped(button: UIButton){
        let tag = button.tag
        
        switch(tag){
        case 0:
            changeFlagStatus("Non existing", button: button, selectedState: "Non_Existent", notSelectedState: "Non_Existent_washed")
        case 1:
            changeFlagStatus("Hard to find", button: button, selectedState: "Hard_to_find", notSelectedState: "Hard_to_find_washed")
        case 2:
            changeFlagStatus("Paid", button: button, selectedState: "Paid", notSelectedState: "Paid_washed")
        case 3:
            changeFlagStatus("Public", button: button, selectedState: "Public", notSelectedState: "Public_washed")
        default:
            NOOP("SHOULD NOT GET HERE!")
        }
    }
    
    // MARK: - HELPER FUNCTIONS
    
    func changeFlagStatus(name:String, button: UIButton, selectedState: String, notSelectedState: String ){
        flagStatusDict[name] = !(flagStatusDict[name]!)
        
        if flagStatusDict[name]!{
            button.setImage(UIImage(named: selectedState), forState: .Normal)
        } else{
            button.setImage(UIImage(named: notSelectedState), forState: .Normal)
        }
    }
}

// MARK: - IMAGE PICKER DELEGATE

extension AddBathroomReviewViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        picker.dismissViewControllerAnimated(true, completion: nil)
        let bathroomImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        imageChooserButton?.image = bathroomImage
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
    
    func dismissKeyboard(){
        self.reviewTextArea?.resignFirstResponder()
    }
}

// MARK: - IMAGE CHOOSER BUTTON DELEGATE

extension AddBathroomReviewViewController: ImageChooserButtonDelegate{
    func imageChooserButton(imageChooserButton: ImageChooserButton, buttonTapped: Bool) {
        photoButtonTapped()
    }
    
    func photoButtonTapped(){
        let ac = UIAlertController(title: "Choose Image", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        ac.addAction(UIAlertAction(title: "Gallery", style: .Default, handler: choosePhoto))
        ac.addAction(UIAlertAction(title: "Camera", style: .Default, handler: newPhoto))
        ac.addAction(UIAlertAction(title: "Close", style: .Default, handler: nil))
        presentViewController(ac, animated: true, completion: nil)
    }
}

// MARK: - TEXTVIEW DELEGATE

extension AddBathroomReviewViewController: UITextViewDelegate{
    func textViewDidBeginEditing(textView: UITextView) {
        textView.text = nil
        textView.textColor = UIColor.blackColor()
    }
}

// MARK: - SETUP VIEWS

extension AddBathroomReviewViewController{
    func setupNavigationBar() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .Plain, target: self, action: "submitBathroom")
        self.navigationController?.hidesBarsOnTap = false
    }
    
    func submitBathroom(){
        var rating: Int = 0
        var flags = [Flag]()
        var comment: String = ""
        //        var location: CLLocationCoordinate2D?
        var picture: UIImage?
        var missingInputs = false
        
        // Get Rating
        if ratingView?.rating != 0{
            rating = ratingView!.rating!
        } else{
            self.ratingView?.layer.borderColor = UIColor.redColor().CGColor
            self.ratingView?.layer.borderWidth = 1
            missingInputs = true
        }
        
        // Get Flags
        for (flagType, flagSet) in flagStatusDict{
            if flagSet{
                flags.append(Flag.flagFromDescription(flagType))
            }
        }
        
        // Get comment
        comment = self.reviewTextArea!.text! ?? ""
        
        if imageChooserButton!.hasImage{
            picture = imageChooserButton?.image
        }
        
        if missingInputs{
            let ac = UIAlertController(title: "Woah! Wait till your poop is done.", message: "Missing inputs", preferredStyle: UIAlertControllerStyle.Alert)
            ac.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.Cancel, handler: nil))
            presentViewController(ac, animated: true, completion: nil)
            return
        }
        
        let review = Review(Id: nil, Rating: Double(rating), ProfileId: UserManager.sharedInstance.profileId!, UserName: UserManager.sharedInstance.name!, BathroomId: bathroom!.id, Comment: comment, Picture: picture, Flags: flags)
        
        reviewWriter.createReview(review){ dict -> Void in
            NOOP("")
        }
    
        print("####### VALUES TO BE SENT #######")
        print(rating)
        print(flags)
        print(comment)
        print(picture)
        
        var controllers = self.navigationController?.viewControllers
        var previous = (controllers?.count)! - 2
        var previousController = controllers![previous]
        self.navigationController?.popToViewController(previousController, animated: true)
    }
    
    func setupRatingView(){
        ratingView?.notSelectedImages = [
            UIImage(named: "Brown_washed")!, UIImage(named: "Bronze_washed")!, UIImage(named: "Gold_washed")!,
            UIImage(named: "Silver_washed")!, UIImage(named: "Porcelain_washed")!]
        ratingView?.fullSelectedImage = [
            UIImage(named: "Brown")!, UIImage(named: "Bronze")!, UIImage(named: "Gold")!,
            UIImage(named: "Silver")!, UIImage(named: "Porcelain")!]
    }
    
    func setupGestureRecognizer(){
        let swipe: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: "dismissKeyboard")
        swipe.direction = .Down
        self.view.addGestureRecognizer(swipe)
    }
    
    func setupReviewTextView(){
        self.reviewTextArea?.text = "Place your review here!"
        self.reviewTextArea?.textColor = UIColor.lightGrayColor()
    }
}

// MARK: - STYLES

extension AddBathroomReviewViewController{
    
    func styleImageChooserButton(){
        self.imageChooserButton?.buttonBackgroundColor = UIColor.colorFromHexRGBValue(0x59E1A6).CGColor
        self.imageChooserButton?.buttonCornerRadius = (imageChooserButton?.buttonHeight)!/2
        self.imageChooserButton?.imageBorderColor = UIColor.blackColor().CGColor
        self.imageChooserButton?.imageBorderWidth = 1.0
    }
    
    func styleNavigationBar() {
        self.navigationController?.navigationBar.barTintColor = UIColor.colorFromHexRGBValue(0x26C27F)
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.translucent = false
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
    }
    
    func styleReviewTextView(){
        self.reviewTextArea?.layer.borderWidth = 1
        self.reviewTextArea?.layer.borderColor = UIColor.colorFromHexRGBValue(0x8A8686).CGColor
        self.reviewTextArea?.cornerRadius = 10
    }
    
    func styleFrameView(){
        self.frameView?.layer.borderWidth = 1
        self.frameView?.layer.borderColor = UIColor.colorFromHexRGBValue(0x8A8686).CGColor
        self.frameView?.layer.opacity = 0.8
        self.frameView?.layer.cornerRadius = 10
    }
    
    func styleDivider(){
        self.divider?.layer.backgroundColor = UIColor.colorFromHexRGBValue(0xC2C2C2).CGColor
    }
    
    func styleBackgroundView(){
        self.backgroundView?.layer.backgroundColor = UIColor.colorFromHexRGBValue(0xBDBDBD).CGColor
    }
=======

class AddBathroomReviewViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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

>>>>>>> Removed .DS_Store from repository
}
