//
//  IReviewWriter.swift
//  YelpForBathrooms
//
//  Created by Mitchell Waldman on 11/30/15.
//  Copyright © 2015 Five Letter. All rights reserved.
//

import Foundation

protocol IReviewWriter {
    func createReview(review: Review, completion: (Dictionary<String, AnyObject> -> Void)?)
}