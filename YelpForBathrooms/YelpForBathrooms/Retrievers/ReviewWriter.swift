//
//  ReviewWriter.swift
//  YelpForBathrooms
//
//  Created by Mitchell Waldman on 11/30/15.
//  Copyright © 2015 Five Letter. All rights reserved.
//

import Foundation
import SwiftyJSON

class ReviewWriter : IReviewWriter {
    var httpRetriever : IHttpRetriever = HttpRetriever()
    
    func createReview(review: Review, completion: (Dictionary<String, AnyObject> -> Void)?){
        var params = [String:AnyObject]()
        params["Rating"] = review.rating
        params["BathroomID"] = review.bathroomId
        params["ProfileID"] = review.profileId
        params["Comment"] = review.comment
        if let picture = review.picture{
            let pictureData = UIImageJPEGRepresentation(picture, 0)
            let base64string = pictureData?.base64EncodedDataWithOptions(.Encoding64CharacterLineLength)
            params["Picture"] = NSString(data: base64string!, encoding: NSUTF8StringEncoding)
        } else{
            params["Picture"] = ""
        }
        params["Non-Existing"] = review.flags.contains({$0.DESCRIPTION == Flag.NON_EXISTING.DESCRIPTION})
        params["Hard-To-Find"] = review.flags.contains({$0.DESCRIPTION == Flag.HARD_TO_FIND.DESCRIPTION})
        params["Public"] = review.flags.contains({$0.DESCRIPTION == Flag.PUBLIC.DESCRIPTION})
        params["Paid"] = review.flags.contains({$0.DESCRIPTION == Flag.PAID.DESCRIPTION})
        
        var requestObject = [String:AnyObject]()
        requestObject["token"] = UserManager.sharedInstance.userToken!
        requestObject["info"] = params
        print("Review Writer Request: \(requestObject)")
        httpRetriever.makeRetrievalRequest(UrlManager.RATING_CREATE, options: requestObject){ data -> Void in
            let json = JSON(data: data)
            print("Review Writer Response: \(json)")
            var response = [String:AnyObject]()
            if let ratingId = json["RatingID"].int {
                response["RatingID"] = ratingId
            }
            if let completion = completion {
                completion(response)
            }
            
        }
    }
}