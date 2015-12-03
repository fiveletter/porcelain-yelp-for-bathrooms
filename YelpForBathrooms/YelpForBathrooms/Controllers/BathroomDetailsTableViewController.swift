//
//  BathroomDetailsTableViewController.swift
//  YelpForBathrooms
//
//  Created by Vince Ly on 12/3/15.
//  Copyright © 2015 Five Letter. All rights reserved.
//

import UIKit
import GoogleMaps

class BathroomDetailsTableViewController: UITableViewController {
    var bathroom: Bathroom!
    var reviews: [Review]!
    var photos = [UIImage]()
    
    func populateData(){
        // POPULATE DATA FOR REVIEWS HERE!!!
        let latDelta: Double = 100
        let longDelta: Double = 100
        let center = CLLocationCoordinate2D(latitude: (100 + 100)/2, longitude: (100 + 100)/2)
        bathroom = Bathroom(Id: 0, Title: "SJSU ENGR 2nd Floor", Location: CLLocationCoordinate2D(latitude: center.latitude + Double(Double(arc4random()) / Double(UINT32_MAX)) * latDelta, longitude: center.longitude + Double(Double(arc4random()) / Double(UINT32_MAX)) * longDelta), Rating: 4.0, Flags: nil)
        reviews = [Review(Id: 10, Rating: 5, ProfileId: 12, UserName: "Big booty Bitch", BathroomId: 0, Comment: "FUCKIN UP ALL NIGHT", Picture: UIImage(named: "Doge"), Flags: [Flag.HARD_TO_FIND, Flag.PAID]), Review(Id: 10, Rating: 4, ProfileId: 12, UserName: "ASS CRACK", BathroomId: 0, Comment: "GOTTA GET THIS SHIT DONE!!!", Picture: UIImage(named: "Doge"), Flags: [Flag.HARD_TO_FIND, Flag.PAID]), Review(Id: 10, Rating: 3, ProfileId: 12, UserName: "ALMOST MORNING JR", BathroomId: 0, Comment: "SOMETIMES I WANT TO CRAWL INTO BED AND CRY MY HEART OUT BECAUSE HOLY GOSH AM I STILL AWAKE TO SEEE THE DAY TURN BACK TO DAY!!! I FINISHED THE BASIC IMPLMENTATION BITCHESSSSSS", Picture: UIImage(named: "Doge"), Flags: [Flag.HARD_TO_FIND, Flag.PAID]), Review(Id: 10, Rating: 2, ProfileId: 12, UserName: "Sorry", BathroomId: 0, Comment: "Sorry for all the profanity that came from this. I'm just glad that I finished the basic implementation.", Picture: UIImage(named: "Doge"), Flags: [Flag.HARD_TO_FIND, Flag.PAID])]
        
        // Grabs Photos from reviews
        getPhotosFromReviews(reviews)
    }

// MARK: - LIFETIME FUNCTIONS
    
    override func viewDidLoad() {
        super.viewDidLoad()
        populateData()
        styleNagivationBar()
        
        setupNavigationBar()
        setupTableView()
    }
    
// MARK: - HELPER FUNCTIONS
    
    func addReview(){
        performSegueWithIdentifier("addReview", sender: self)
    }
    
    func getPhotosFromReviews(reviewsList: [Review]){
        for review in reviewsList{
            if let image = review.picture{
                photos.append(image)
            }
        }
    }
    
    func getReuseIdentifierFromIndexPath(indexPath: NSIndexPath) -> String{
        let reuseIdentifier:String
        
        switch (indexPath.item){
        case 0:
            reuseIdentifier = "flagCell"
        case 1:
            reuseIdentifier = "mapCell"
        case 2:
            reuseIdentifier = "photosCell"
        default:
            reuseIdentifier = "aCell"
        }
        return reuseIdentifier
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let segueIdentifier = segue.identifier{
            switch segueIdentifier{
            case "addReview":
                let addBathroomReviewViewController = segue.destinationViewController as! AddBathroomReviewViewController
                addBathroomReviewViewController.bathroom = bathroom
            default:
                NOOP("UNREACHABLE")
            }
        }
    }

// MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numberOfRows: Int = 0
        switch(section){
        case 0:
            numberOfRows = 4
        case 1:
            numberOfRows = reviews.count
        default:
            NOOP("SHOULD NOT GET HERE!!")
        }
        return numberOfRows
    }

// MARK: - Setup Cell views
// I KNOW ITS A LONG FUNCTION BUT WHATEVER! >:(
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 1{
            let cell = tableView.dequeueReusableCellWithIdentifier("reviewCell") as! ReviewCell
            let review = reviews[indexPath.row]
            cell.nameLabel.text = review.username
            cell.commentTextArea.text = review.comment
            cell.ratingView.notSelectedImages = [
                UIImage(named: "Brown_washed")!, UIImage(named: "Bronze_washed")!, UIImage(named: "Gold_washed")!,
                UIImage(named: "Silver_washed")!, UIImage(named: "Porcelain_washed")!]
            cell.ratingView.fullSelectedImage = [
                UIImage(named: "Brown")!, UIImage(named: "Bronze")!, UIImage(named: "Gold")!,
                UIImage(named: "Silver")!, UIImage(named: "Porcelain")!]
            cell.ratingView.editable = false
            cell.ratingView.rating = Int(review.rating)
            cell.frameView.layer.borderColor = UIColor.blackColor().CGColor
            cell.frameView.layer.borderWidth = 1.0
            cell.frameView.layer.cornerRadius = 10
            return cell

        }
        
        switch(indexPath.item){
        case 0:
            let headerCell = tableView.dequeueReusableCellWithIdentifier("header") as! DetailsHeaderView
            headerCell.titleLabel.text = bathroom.title
            headerCell.headerImageView.image = reviews[0].picture ?? UIImage(named: "Doge")
            headerCell.ratingView.notSelectedImages = [
                UIImage(named: "Brown_washed")!, UIImage(named: "Bronze_washed")!, UIImage(named: "Gold_washed")!,
                UIImage(named: "Silver_washed")!, UIImage(named: "Porcelain_washed")!]
            headerCell.ratingView.fullSelectedImage = [
                UIImage(named: "Brown")!, UIImage(named: "Bronze")!, UIImage(named: "Gold")!,
                UIImage(named: "Silver")!, UIImage(named: "Porcelain")!]
            headerCell.ratingView.editable = false
            headerCell.ratingView.rating = Int(bathroom.rating!)
            headerCell.imageView?.image?.alpha(0.6)
            return headerCell
        case 1:
            let cell = tableView.dequeueReusableCellWithIdentifier("flagCell") as! FlagsCell
            return cell
        case 2:
            let cell = tableView.dequeueReusableCellWithIdentifier("mapCell") as! MapCell
            cell.mapView.settings.setAllGesturesEnabled(false)
            return cell
        case 3:
            let cell = tableView.dequeueReusableCellWithIdentifier("photosCell") as! PhotosCell
            cell.collectionView.backgroundColor = UIColor.whiteColor()
            return cell
        default:
            let cell = tableView.dequeueReusableCellWithIdentifier("aCell")!
            return cell
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let height: CGFloat
        if indexPath.section == 1{
            return 150
        }
        switch (indexPath.item){
        case 0:
            height = 150
        case 1:
            height = 95.0
        case 2:
            height = 280.0
        case 3:
            height = 250.0
        default:
            height = 50.0
        }
        return height
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        guard let tableViewCell = cell as? PhotosCell else {return}
        
        tableViewCell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.item)
    }
    

// MARK: - Header Views
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var cell: UITableViewCell! = nil
        if section == 1{
            cell = tableView.dequeueReusableCellWithIdentifier("reviewHeader")!
        }
        
        return cell
    }
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let height:CGFloat
        switch(section){
        case 0:
            height = 0.0
        default:
            height = 50.0
        }
        return height
    }
    
}

// MARK: - COLLECTION VIEW DELEGATE FUNCTIONS

extension BathroomDetailsTableViewController: UICollectionViewDataSource, UICollectionViewDelegate{
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("photoCollectionCell", forIndexPath: indexPath) as! photoCollectionViewCell
        cell.imageView.image = photos[indexPath.row]
        
        return cell
    }
}


// MARK: - SETUP FUNCTIONS

extension BathroomDetailsTableViewController{
    func setupNavigationBar(){
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add Review", style: UIBarButtonItemStyle.Plain, target: self, action: "addReview")
    }
    
    func setupTableView(){
        tableView.bounces = false
        tableView.allowsSelection = false
    }
}

// MARK: - STYLE FUNCTIONS

extension BathroomDetailsTableViewController{
    
    func styleTable(){
        tableView.layer.backgroundColor = UIColor.colorFromHexRGBValue(0xBDBDBD).CGColor
    }
    func styleNagivationBar(){
        self.navigationController?.navigationBar.topItem?.title = "Porcelain"
    }
}
