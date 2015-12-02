//
//  Model.swift
//  YelpForBathrooms
//
//  Created by Vince Ly on 11/14/15.
//  Copyright © 2015 Five Letter. All rights reserved.
//

import Foundation
import GoogleMaps

class Bathroom {

//  MARK: - PROPERTIES
    var id : Int?
    var title : String
    var location : CLLocationCoordinate2D
    var rating : Double?
    var flags : [Flag]?
    
//  MARK: - INITIALIZERS
    init(){
        id = -1;
        title = "NO TITLE"
        location = CLLocationCoordinate2D()
        rating = 0.0
        flags = [];
    }

    init(Id: Int?, Title: String, Location: CLLocationCoordinate2D, Rating : Double?, Flags: [Flag]?){
        id = Id
        title = Title
        location = Location
        rating = Rating
        flags = Flags
    }
}