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
    var username : String
    var bathroomId : Int?
    var comment : String
    var picture : UIImage? //base64
    var flags : [Flag]
    
//  MARK: - INITIALIZERS
    init(){
        id = 0
        rating = 0
        profileId = 0
        username = ""
        bathroomId = nil
        comment = ""
        picture = nil
        flags = []
    }
    

    init(Id : Int?, Rating: Double, ProfileId : Int, UserName: String, BathroomId: Int?, Comment: String, Picture: UIImage?, Flags:  [Flag]){
        id = Id
        rating = Rating
        profileId = ProfileId
        username = UserName
        bathroomId = BathroomId
        comment = Comment
        picture = Picture
        flags = Flags
    }
}