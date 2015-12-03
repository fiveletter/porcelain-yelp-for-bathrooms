//
//  ReviewCell.swift
//  YelpForBathrooms
//
//  Created by Vince Ly on 12/3/15.
//  Copyright © 2015 Five Letter. All rights reserved.
//

import UIKit

class ReviewCell: UITableViewCell{
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ratingView: RatingView!
    @IBOutlet weak var commentTextArea: UITextView!
    @IBOutlet weak var frameView: UIView!
}
