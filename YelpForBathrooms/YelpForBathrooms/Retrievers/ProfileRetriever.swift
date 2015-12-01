//
//  ProfileRetriever.swift
//  YelpForBathrooms
//
//  Created by Mitchell Waldman on 11/28/15.
//  Copyright © 2015 Five Letter. All rights reserved.
//

import Foundation
import SwiftyJSON

class ProfileRetriever : IProfileRetriever {
    var httpRetriever : IHttpRetriever = HttpRetriever()
    func getProfileId(email: String, completion: (Int? -> Void)) {
        httpRetriever.makeRetrievalRequest(UrlManager.PROFILE_RETRIEVE, options: ["Email" : email]){ data -> Void in
            let json = JSON(data: data)
            if let profileId = json["ProfileID"].int {
                completion(profileId)
            } else {
                completion(nil)
            }
        }
    }
    
    func createProfile(first: String, last: String, email: String, completion: (Int? -> Void)) {
        var params = [String:AnyObject]()
        params["FirstName"] = first
        params["LastName"] = last
        params["Email"] = email
        httpRetriever.makeRetrievalRequest(UrlManager.PROFILE_CREATE, options: params){
            (data) -> Void in
            let json = JSON(data: data)
            if let profileId = json["ProfileID"].int {
                completion(profileId)
            } else {
                completion(nil)
            }
        }
    }
}