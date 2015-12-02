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

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func openAddReview() {
        performSegueWithIdentifier("addBathroomReviewSegue", sender: self)
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
