//
//  FakeBathroomRetriever.swift
//  YelpForBathrooms
//
//  Created by Mitchell Waldman on 11/24/15.
//  Copyright © 2015 Five Letter. All rights reserved.
//

import Foundation
import GoogleMaps

class FakeBathroomRetriever : IBathroomRetriever {
    func GetBathrooms(location: CLLocation, radius: CGFloat) -> [Bathroom]? {
        return nil;
    }
}