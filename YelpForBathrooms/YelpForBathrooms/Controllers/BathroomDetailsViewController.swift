//
//  BathroomDetailsViewController.swift
//  YelpForBathrooms
//
//  Created by Vince Ly on 11/21/15.
//  Copyright © 2015 Five Letter. All rights reserved.
//

import UIKit
import GoogleMaps

class BathroomDetailsViewController: UIViewController {
    var bathroom: Bathroom!
    var reviews: [Review]!
    
    var dataSource: DetailsViewDataSource!
    @IBOutlet var tableView: YLTableView!
    
    func populateDummyData(){
        let latDelta: Double = 100
        let longDelta: Double = 100
        let center = CLLocationCoordinate2D(latitude: (100 + 100)/2, longitude: (100 + 100)/2)
         bathroom = Bathroom(Id: 0, Title: "SJSU ENGR 2nd Floor", Location: CLLocationCoordinate2D(latitude: center.latitude + Double(Double(arc4random()) / Double(UINT32_MAX)) * latDelta, longitude: center.longitude + Double(Double(arc4random()) / Double(UINT32_MAX)) * longDelta), Rating: 4.0, Flags: nil)
        reviews = [Review(Id: 10, Rating: 5, ProfileId: 12, UserName: "Big booty Bitch", BathroomId: 0, Comment: "FUCKIN UP ALL NIGHT", Picture: UIImage(named: "Doge"), Flags: [Flag.HARD_TO_FIND, Flag.PAID])]
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        populateDummyData()
        styleNagivationBar()
        
        dataSource = DetailsViewDataSource()
        dataSource.headerModel = DetailsHeaderModel(title: bathroom.title, rating: bathroom.rating!, headerImage: reviews.first?.picture)
        
        tableView.dataSource = dataSource
        tableView.delegate = dataSource
        // Do any additional setup after loading the view.
    }
    
    @IBAction func openAddReview() {
        performSegueWithIdentifier("addBathroomReviewSegue", sender: self)
    }
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
// MARK: - STYLES

extension BathroomDetailsViewController{
    func styleNagivationBar(){
        self.navigationController?.navigationBar.topItem?.title = "Porcelain"
    }
}
