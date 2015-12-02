//
//  UrlManager.swift
//  YelpForBathrooms
//
//  Created by Mitchell Waldman on 11/28/15.
//  Copyright © 2015 Five Letter. All rights reserved.
//

import Foundation
class UrlManager {
    class var BASE_URL : String {
        get {
            var url : String = ""
            if let path = NSBundle.mainBundle().pathForResource("Info", ofType: "plist") {
                if let myDict = NSDictionary(contentsOfFile: path)
                {
                    url = myDict["BASE_URL"] as! String
                } else {
                }
            }
            return url
        }
        set{
            
        }
    }
    class var PROFILE_AUTH : String {
        get {
            return BASE_URL + "/profile/auth"
        } set {
            
        }
    }
    class var BATHROOM_CREATE : String {
        get {
        return BASE_URL + "/bathroom/create"
        }
        set{
            
        }
    }
    
    class var BATHROOM_UPDATE : String {
        get {
        return BASE_URL + "/bathroom/update"
        }
        set{
            
        }
    }
    
    class var BATHROOM_DELETE : String {
        get {
        return BASE_URL + "/bathroom/delete"
        }
        set{
            
        }
    }
    
    class var BATHROOM_RETRIEVE : String {
        get {
            return BASE_URL + "/bathroom/retrieve"
        }
        set{
            
        }
    }
    
    class var RATING_CREATE : String {
        get {
        return BASE_URL + "/rating/create"
        }
        set{
            
        }
    }
    
    class var RATING_UPDATE : String {
        get {
        return BASE_URL + "/rating/update"
        }
        set{
            
        }
    }
    
    class var RATING_DELETE : String {
        get {
        return BASE_URL + "/rating/delete"
        }
        set{
            
        }
    }
    
    class var RATING_RETRIEVE : String {
        get {
        return BASE_URL + "/rating/retrieve"
        }
        set{
            
        }
    }
    class var PROFILE_CREATE : String {
        get {
            return BASE_URL + "/profile/create"
        }
        set{
            
        }
    }
    
    class var PROFILE_RETRIEVE : String {
        get {
            return BASE_URL + "/profile/retrieve"
        }
        set{
            
        }
    }
    
    class var PROFILE_UPDATE : String {
        get {
            return BASE_URL + "/profile/update"
        }
        set{
            
        }
    }
    
    class var PROFILE_DELETE : String {
        get {
            return BASE_URL + "/profile/delete"
        }
        set{
            
        }
    }
    
}