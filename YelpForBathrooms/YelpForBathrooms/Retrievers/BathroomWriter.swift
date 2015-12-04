//
//  BathroomWriter.swift
//  YelpForBathrooms
//
//  Created by Mitchell Waldman on 11/30/15.
//  Copyright © 2015 Five Letter. All rights reserved.
//

import Foundation
import SwiftyJSON

class BathroomWriter : IBathroomWriter {
    var httpRetriever : IHttpRetriever = HttpRetriever()
    
    func createBathroom(bathroom: Bathroom, review: Review, completion: (Dictionary<String, AnyObject> -> Void)?){
        var params = [String:AnyObject]()
        params["Longitude"] = bathroom.location.longitude
        params["Latitude"] = bathroom.location.latitude
        params["Title"] = bathroom.title
        if let picture = review.picture{
            let pictureData = UIImageJPEGRepresentation(picture, 0)
            let base64string = pictureData?.base64EncodedDataWithOptions(.Encoding64CharacterLineLength)
            params["Picture"] = NSString(data: base64string!, encoding: NSUTF8StringEncoding)
        } else{
            params["Picture"] = ""
        }
        params["Rating"] = review.rating
        params["ProfileID"] = review.profileId
        params["Comment"] = review.comment
        //TODO: Tell khalil to update bathrom/create api to allow flags sent in
        params["Non-Existing"] = review.flags.contains({$0.DESCRIPTION == Flag.NON_EXISTING.DESCRIPTION})
        params["Hard-To-Find"] = review.flags.contains({$0.DESCRIPTION == Flag.HARD_TO_FIND.DESCRIPTION})
        params["Public"] = review.flags.contains({$0.DESCRIPTION == Flag.PUBLIC.DESCRIPTION})
        params["Paid"] = review.flags.contains({$0.DESCRIPTION == Flag.PAID.DESCRIPTION})
        
        var requestObj = [String:AnyObject]()
        requestObj["token"] = UserManager.sharedInstance.userToken
        requestObj["info"] = params
        print("Bathroom Writer Request: \(requestObj)")
        httpRetriever.makeRetrievalRequest(UrlManager.BATHROOM_CREATE, options: requestObj){ data -> Void in
            let json = JSON(data: data)
            print("Bathroom Writer Response: \(json)")
            var response = [String:AnyObject]()
            if let bathroomId = json["BathroomID"].int {
                response["BathroomID"] = bathroomId
            }
            if let reviewId = json["ReviewID"].int {
                response["ReviewID"] = reviewId
            }
            if let completion = completion{
                completion(response)
            }
        }
    }
}