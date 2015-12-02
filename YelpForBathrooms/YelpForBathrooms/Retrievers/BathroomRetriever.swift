//
//  BathroomRetriever.swift
//  YelpForBathrooms
//
//  Created by Mitchell Waldman on 11/24/15.
//  Copyright © 2015 Five Letter. All rights reserved.
//

import Foundation
import GoogleMaps
import SwiftyJSON

class BathroomRetriever : IBathroomRetriever {
    var httpRetriever : IHttpRetriever = HttpRetriever()
    
    func GetBathrooms(area: GMSVisibleRegion, completion: ([Bathroom]? -> Void)) {
        let url : String = UrlManager.BATHROOM_RETRIEVE
        var bathrooms = [Bathroom]()
        let parameters = GetBathroomRetrievalParametersFromArea(area)
        print("Bathroom Retrieval Request: \(parameters)")
        httpRetriever.makeRetrievalRequest(url, options: parameters) { data -> Void in
            let json = JSON(data: data)
            print("Bathroom Retrieval Response: \(json)")
            if let status = json["response"].string where status == "success" {
                for (_, subJson): (String, JSON) in json["info"] {
                    let bathroomId = subJson["BathroomID"].int
                    let lat = subJson["Latitude"].double
                    let long = subJson["Longitude"].double
                    let title = subJson["Title"].string
                    let numOfPublicFlags = subJson["Public"].int
                    let numOfNonExistingFlags = subJson["Non-Existing"].int
                    let numOfHardToFindFlags = subJson["Hard-To-Find"].int
                    let numOfPaidFlags = subJson["Paid"].int
                    
                    let coordinate = CLLocationCoordinate2D(latitude: lat!, longitude: long!)
                    var flags = [Flag]()
                    for _ in 0..<numOfPublicFlags! {
                        flags.append(Flag.PUBLIC)
                    }
                    for _ in 0..<numOfNonExistingFlags! {
                        flags.append(Flag.NON_EXISTING)
                    }
                    for _ in 0..<numOfHardToFindFlags! {
                        flags.append(Flag.HARD_TO_FIND)
                    }
                    for _ in 0..<numOfPaidFlags! {
                        flags.append(Flag.PAID)
                    }
                    print("Adding in bathroom: id: \(bathroomId) title: \(title) location: \(coordinate)")
                    let bathroom = Bathroom(Id: bathroomId!, Title: title!, Location: coordinate, Rating: 2, Flags: flags)
                    bathrooms.append(bathroom)
                }
               completion(bathrooms);
            } else {
                print(json)
                completion(nil)
            }
        }
    }
    
    private func GetBathroomRetrievalParametersFromArea(area:GMSVisibleRegion) -> Dictionary<String, AnyObject>{
        var params = [String:AnyObject]()
        let maxLat = max(area.farLeft.latitude, area.farRight.latitude, area.nearLeft.latitude, area.nearRight.latitude)
        let minLat = min(area.farLeft.latitude, area.farRight.latitude, area.nearLeft.latitude, area.nearRight.latitude)
        let maxLong = max(area.farLeft.longitude, area.farRight.longitude, area.nearLeft.longitude, area.nearRight.longitude)
        let minLong = min(area.farLeft.longitude, area.farRight.longitude, area.nearLeft.longitude, area.nearRight.longitude)
        //params["MinLat"] = minLat.description
        //params["MaxLat"] = maxLat.description
        //params["MinLong"] = minLong.description
        //params["MaxLong"] = maxLong.description
        params["Radius"] = 1
        params["Latitude"] = maxLat
        params["Longitude"] = maxLong
        return params
    }
}