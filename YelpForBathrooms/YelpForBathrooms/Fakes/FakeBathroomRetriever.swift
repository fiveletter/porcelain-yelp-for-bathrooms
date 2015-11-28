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
    
    func GetBathrooms(area: GMSVisibleRegion) -> [Bathroom]? {
        var bathrooms : [Bathroom] = [];
        for _ in 1...20 {
            bathrooms.append(CreateBathroom(area))
        }
        return bathrooms
    }
    
    private func CreateBathroom(area: GMSVisibleRegion) -> Bathroom {
        let maxLat = max(area.farLeft.latitude, area.farRight.latitude, area.nearLeft.latitude, area.nearRight.latitude)
        let minLat = min(area.farLeft.latitude, area.farRight.latitude, area.nearLeft.latitude, area.nearRight.latitude)
        let maxLong = max(area.farLeft.longitude, area.farRight.longitude, area.nearLeft.longitude, area.nearRight.longitude)
        let minLong = min(area.farLeft.longitude, area.farRight.longitude, area.nearLeft.longitude, area.nearRight.longitude)
        
        let latDelta = maxLat - minLat
        let longDelta = maxLong - minLong
        let center = CLLocationCoordinate2D(latitude: (maxLat + minLat)/2, longitude: (minLong + maxLong)/2)
        
        
        let location : CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: center.latitude + Double(Double(arc4random()) / Double(UINT32_MAX)) * latDelta, longitude: center.longitude + Double(Double(arc4random()) / Double(UINT32_MAX)) * longDelta)
        let title : String = "Random Bathroom @ lat: \(location.latitude) and long: \(location.longitude)"
        let id : Int = Int(location.latitude + location.longitude)
        let rating : Double = Double(arc4random_uniform(5))
        let flags : [Flag] = [Flag.PUBLIC, Flag.NON_EXISTING, Flag.HARD_TO_FIND, Flag.PUBLIC]
        let bathroom : Bathroom = Bathroom(Id: id, Title: title, Location: location, Rating: rating, Flags: flags)
        return bathroom
    }
}
