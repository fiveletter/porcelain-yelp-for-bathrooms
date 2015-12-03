//
//  BathroomSnippetView.swift
//  YelpForBathrooms
//
//  Created by Mitchell Waldman on 11/25/15.
//  Copyright © 2015 Five Letter. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class BathroomSnippetView: UIView {
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var ratingView: RatingView!
    @IBOutlet weak var nonExistentFlag: UIImageView!
    @IBOutlet weak var paidFlag: UIImageView!
    @IBOutlet weak var hardToFindFlag: UIImageView!
    @IBOutlet weak var publicFlag: UIImageView!
}
