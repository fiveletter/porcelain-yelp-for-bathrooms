//
//  BathroomDetailRetriever.swift
//  YelpForBathrooms
//
//  Created by Mitchell Waldman on 11/24/15.
//  Copyright © 2015 Five Letter. All rights reserved.
//

import Foundation
import SwiftyJSON

class BathroomDetailRetriever : IBathroomDetailRetriever {
    var httpRetriever : IHttpRetriever = HttpRetriever()
    
    func GetBathroomDetail(bathroomId: Int, completion: (BathroomDetail? -> Void)) {
        let url = UrlManager.RATING_RETRIEVE
        let bathroomDetail = BathroomDetail()
        var reviews = [Review]()
        var parameters = [String: AnyObject]()
        parameters["BathroomID"] = bathroomId
        print("Bathroom Details Retrieval Request: \(parameters)")
        httpRetriever.makeRetrievalRequest(url, options: parameters) { data -> Void in
            let json = JSON(data: data)
            print("Bathroom Details Retrieval Response: \(json)")
            if let status = json["response"].string where status == "uccess"{
                for (_, subJson): (String, JSON) in json["info"] {
                    let ratingId = subJson["RatingID"].int
                    let rating = subJson["Rating"].double
                    let profileId = subJson["ProfileID"].int
                    let bathroomId = subJson["BathroomID"].int
                    let comment = subJson["Comment"].string
                    let pictureURL = subJson["PictureURL"].string
                    var picture : UIImage?
                    if let imageURL = NSURL(string: pictureURL!), let data = NSData(contentsOfURL: imageURL), let image = UIImage(data: data) {
                        picture = image
                    }
                    let firstName = subJson["FirstName"].string
                    let lastName = subJson["LastName"].string
                    let nonExisting = subJson["Non-Existing"].boolValue
                    let hardToFind = subJson["Hard-To-Find"].boolValue
                    let publicFlag = subJson["Public"].boolValue
                    let paid = subJson["Paid"].boolValue
                    
                    var flags = [Flag]()
                    if( nonExisting ) {
                        flags.append(Flag.NON_EXISTING)
                    }
                    if( hardToFind ) {
                        flags.append(Flag.HARD_TO_FIND)
                    }
                    if( publicFlag) {
                        flags.append(Flag.PUBLIC)
                    }
                    if( paid ) {
                        flags.append(Flag.PAID)
                    }
                    
                    let review = Review(Id: ratingId, Rating: rating!, ProfileId: profileId!, UserName: firstName! + " " + lastName!, BathroomId: bathroomId!, Comment: comment!, Picture: picture, Flags: flags)
                    reviews.append(review)
                }
                bathroomDetail.reviews = reviews
                completion(bathroomDetail);
            } else {
                completion(nil)
            }
        }

    }
}