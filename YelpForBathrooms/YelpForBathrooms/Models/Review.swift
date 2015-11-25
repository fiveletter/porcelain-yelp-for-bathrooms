//
//  Review.swift
//  YelpForBathrooms
//
//  Created by Mitchell Waldman on 11/24/15.
//  Copyright © 2015 Five Letter. All rights reserved.
//

import Foundation

class Review {
//  MARK: - PROPERTIES
    var id : Int?
    var rating : Double
    var profileId : Int
    var bathroomId : Int
    var comment : String
    var picture : NSURL
    
//  MARK: - INITIALIZERS
    init(){
        id = 0
        rating = 0
        profileId = 0
        bathroomId = 0
        comment = ""
        picture = NSURL()
    }
    
    init(Id : Int?, Rating: Double, ProfileId : Int, BathroomId: Int, Comment: String, Picture: NSURL){
        id = Id
        rating = Rating
        profileId = ProfileId
        bathroomId = BathroomId
        comment = Comment
        picture = Picture
    }
}