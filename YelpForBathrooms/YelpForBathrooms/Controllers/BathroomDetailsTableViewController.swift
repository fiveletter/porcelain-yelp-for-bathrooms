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
    var bathroomDetailsRetriever : IBathroomDetailRetriever = BathroomDetailRetriever()
    var isLoadingReviews = false;
    
    func populateData(){
        // POPULATE DATA FOR REVIEWS HERE!!!
        isLoadingReviews = true;
        
        bathroomDetailsRetriever.GetBathroomDetail(bathroom.id!){ bathroomDetails -> Void in
            if let bathroomDetails = bathroomDetails{
                self.reviews = bathroomDetails.reviews
                self.getPhotosFromReviews(self.reviews)
            }
            self.isLoadingReviews = false
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.tableView.reloadData()
            })
        }
    }

// MARK: - LIFETIME FUNCTIONS
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTableView()
        styleNagivationBar()
        
        setupNavigationBar()
        populateData()
    }
    
// MARK: - HELPER FUNCTIONS
    
    func addReview(){
        if UserManager.sharedInstance.IsSignedIn {
            performSegueWithIdentifier("addReview", sender: self)
        } else {
            let ac = UIAlertController(title: "Sign in to add a review", message: "User not signed in", preferredStyle: UIAlertControllerStyle.Alert)
            ac.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.Cancel, handler: nil))
            presentViewController(ac, animated: true, completion: nil)
            return
        }
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
            if isLoadingReviews {
                numberOfRows = 0
            } else {
                numberOfRows = reviews.count
            }
        default:
            NOOP("SHOULD NOT GET HERE!!")
        }
        return numberOfRows
    }

// MARK: - Setup Cell views
// I KNOW ITS A LONG FUNCTION BUT WHATEVER! >:(
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if !isLoadingReviews {
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
                cell.ratingView.rating = Int(review.rating)
                cell.ratingView.editable = false
                cell.frameView.layer.borderColor = UIColor.blackColor().CGColor
                cell.frameView.layer.borderWidth = 1.0
                cell.frameView.layer.cornerRadius = 10
                return cell

            }
            
            switch(indexPath.item){
            case 0:
                let headerCell = tableView.dequeueReusableCellWithIdentifier("header") as! DetailsHeaderView
                headerCell.titleLabel.text = bathroom.title
                let picReviews = reviews.filter(){
                    if let _ = $0.picture {
                        return true;
                    }
                    return false
                }
                headerCell.headerImageView.image = picReviews.last?.picture ?? UIImage(named: "Doge")
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
                cell.mapView.myLocationEnabled = true
                cell.mapView.animateToLocation(bathroom.location)
                cell.mapView.animateToZoom(15)
                let marker = GMSMarker(position: bathroom.location)
                marker.map = cell.mapView
                return cell
            case 3:
                let cell = tableView.dequeueReusableCellWithIdentifier("photosCell") as! PhotosCell
                cell.collectionView.backgroundColor = UIColor.whiteColor()
                return cell
            default:
                let cell = tableView.dequeueReusableCellWithIdentifier("aCell")!
                return cell
            }
        } else {
            if indexPath.section == 1 {
                let cell = tableView.dequeueReusableCellWithIdentifier("reviewCell") as! ReviewCell
                return cell
            }
            switch(indexPath.item){
            case 0:
                let headerCell = tableView.dequeueReusableCellWithIdentifier("header") as! DetailsHeaderView
                headerCell.titleLabel.text = bathroom.title
                headerCell.headerImageView.image = UIImage(named: "Doge")
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
                if let flags = bathroom.flags {
                    for flag in flags {
                        if flag.FLAG_ID == Flag.HARD_TO_FIND.FLAG_ID {
                            cell.hardToFindFlag.image = UIImage(named: "Hard_to_find")
                        } else if flag.FLAG_ID == Flag.NON_EXISTING.FLAG_ID {
                            cell.nonExistentFlag.image = UIImage(named: "Non_Existent")
                        } else if flag.FLAG_ID == Flag.PAID.FLAG_ID {
                            cell.paidFlag.image = UIImage(named: "Paid")
                        } else if flag.FLAG_ID == Flag.PUBLIC.FLAG_ID{
                            cell.publicFlag.image = UIImage(named: "Public")
                        }
                    }
                }
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
