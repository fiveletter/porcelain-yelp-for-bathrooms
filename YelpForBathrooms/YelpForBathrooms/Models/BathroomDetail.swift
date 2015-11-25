//
//  BathroomDetail.swift
//  YelpForBathrooms
//
//  Created by Mitchell Waldman on 11/24/15.
//  Copyright © 2015 Five Letter. All rights reserved.
//

import Foundation
import GoogleMaps

class BathroomDetail : Bathroom {
//  MARK: - PROPERTIES
    var reviews : [Review]
    
//  MARK: - INITIALIZERS
    override init(){
        reviews = [];
        super.init()
    }
    
    init(Id: Int, Title: String, Location: CLLocationCoordinate2D, Rating : Double, Flags: [Flag], Reviews: [Review]){
        reviews = Reviews
        super.init(Id: Id, Title: Title, Location: Location, Rating: Rating, Flags: Flags)
    }
}