//
//  IBathroomRetriever.swift
//  YelpForBathrooms
//
//  Created by Mitchell Waldman on 11/24/15.
//  Copyright © 2015 Five Letter. All rights reserved.
//

import Foundation
import GoogleMaps

protocol IBathroomRetriever {
    func GetBathrooms(area:GMSVisibleRegion, completion: ([Bathroom]? -> Void))
}