//
//  IBathroomWriter.swift
//  YelpForBathrooms
//
//  Created by Mitchell Waldman on 11/30/15.
//  Copyright © 2015 Five Letter. All rights reserved.
//

import Foundation

protocol IBathroomWriter {
    func createBathroom(bathroom: Bathroom, review: Review, completion: (Dictionary<String, AnyObject> -> Void)?)
}