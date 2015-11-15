//
//  ConfigManager.swift
//  YelpForBathrooms
//
//  Created by Mitchell Waldman on 11/30/15.
//  Copyright © 2015 Five Letter. All rights reserved.
//

import Foundation

class ConfigManager {
    class var GOOGLE_PLACES_API_KEY : String {
        get {
            var key : String = "no key specified"
            if let path = NSBundle.mainBundle().pathForResource("Info", ofType: "plist") {
                if let myDict = NSDictionary(contentsOfFile: path)
                {
                    key = myDict["GOOGLE_PLACES_API_KEY"] as! String
                } else {
                }
            }
            return key
        }
        set{
            
        }
    }
}