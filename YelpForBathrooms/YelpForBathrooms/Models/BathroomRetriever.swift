//
//  BathroomRetriever.swift
//  YelpForBathrooms
//
//  Created by Mitchell Waldman on 11/24/15.
//  Copyright © 2015 Five Letter. All rights reserved.
//

import Foundation
import GoogleMaps

class BathroomRetriever : IBathroomRetriever {
    static var httpRetriever = HttpRetriever()
    
    func GetBathrooms(area: GMSVisibleRegion) -> [Bathroom]? {
        return nil;
    }
}