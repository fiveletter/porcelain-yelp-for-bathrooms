//
//  BathroomDetailsViewController.swift
//  YelpForBathrooms
//
//  Created by Vince Ly on 11/21/15.
//  Copyright © 2015 Five Letter. All rights reserved.
//

import UIKit

class BathroomDetailsViewController: UIViewController {
    var bathroom: Bathroom!
    var reviews: [Review]?
    var bathroomDetailRetriever : IBathroomDetailRetriever = BathroomDetailRetriever()
    @IBOutlet weak var firstPic: UIImageView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        bathroomDetailRetriever.GetBathroomDetail(bathroom.id!){ bathroomDetail -> Void in
            if let reviews = bathroomDetail?.reviews{
                self.reviews = reviews
                print(reviews)
                var review = reviews.filter(){
                    if let picture = $0.picture {
                        return true;
                    }
                    return false
                }
                self.firstPic.image = review.first?.picture
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func openAddReview() {
        if UserManager.sharedInstance.IsSignedIn{
            performSegueWithIdentifier("addBathroomReviewSegue", sender: self)
        } else {
            let ac = UIAlertController(title: "Sign in to add a review", message: "Not signed in.", preferredStyle: UIAlertControllerStyle.Alert)
            ac.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.Cancel, handler: nil))
            presentViewController(ac, animated: true, completion: nil)
            return
        }
        
    }

    func populateDetailScreen() {
        //Do shit with bathroom details
    }

// MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let segueIdentifier = segue.identifier{
            switch(segueIdentifier){
            case "addBathroomReviewSegue":
                let addBathroomReviewViewController = segue.destinationViewController as! AddBathroomReviewViewController
                addBathroomReviewViewController.bathroom = bathroom
            default:
                NOOP("DO NOTHING")
            }
        }
    }

}
