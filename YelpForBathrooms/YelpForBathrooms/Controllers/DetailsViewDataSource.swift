//
//  YLExampleTextCell.swift
//  YelpForBathrooms
//
//  Created by Vince Ly on 12/2/15.
//  Copyright © 2015 Five Letter. All rights reserved.
//

import UIKit

class DetailsViewDataSource: YLTableViewDataSource{
    var models = [String]()
    var headerModel: DetailsHeaderModel!
    
    override init() {
        super.init()
        models.append("FUCK")
        models.append("BOI")
        headerModel = DetailsHeaderModel()
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch(section){
        case 0:
            let headerCell = tableView.dequeueReusableCellWithIdentifier("header") as! DetailsHeaderView
            headerCell.titleLabel.text = headerModel.title
            headerCell.headerImageView.image = headerModel.headerImage
            headerCell.ratingView.notSelectedImages = [
                UIImage(named: "Brown_washed")!, UIImage(named: "Bronze_washed")!, UIImage(named: "Gold_washed")!,
                UIImage(named: "Silver_washed")!, UIImage(named: "Porcelain_washed")!]
            headerCell.ratingView.fullSelectedImage = [
                UIImage(named: "Brown")!, UIImage(named: "Bronze")!, UIImage(named: "Gold")!,
                UIImage(named: "Silver")!, UIImage(named: "Porcelain")!]
            headerCell.ratingView.rating = Int(headerModel.rating)
            headerCell.ratingView.editable = false
            headerCell.imageView?.image?.alpha(0.6)
            return headerCell
        default:
            NOOP("SHOULD NOT GET HERE")
        }
        return nil
    }
    
    override func tableView(tableView: UITableView, reuseIdentifierForCellAtIndexPath indexPath: NSIndexPath) -> String {
        let reuseIdentifier:String
        
        switch (indexPath.item){
        case 2:
            reuseIdentifier = "anotherCell"
        default:
            reuseIdentifier = "aCell"
        }
        return reuseIdentifier
    }
    
    override func tableView(tableView: UITableView, modelForCellAtIndexPath indexPath: NSIndexPath) -> AnyObject {
        return models[indexPath.item]
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let height: CGFloat
        switch (indexPath.item){
        case 2:
            height = 100.0
        default:
            height = 50.0
        }
        return height
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let height: CGFloat
        switch (section){
        case 0:
            height = 150.0
        default:
            height = 50.0
        }
        return height
        
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
}