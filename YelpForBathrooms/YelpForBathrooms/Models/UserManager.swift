//
//  File.swift
//  YelpForBathrooms
//
//  Created by Mitchell Waldman on 11/22/15.
//  Copyright © 2015 Five Letter. All rights reserved.
//

import Foundation

class UserManager {
    var email : String?
    var name : String?
    
    init(){
        
    }
    
    init(userEmail : String?, userName: String?) {
        email = userEmail
        name = userName
    }
    
    var IsSignedIn : Bool {
        get {
            if let _ = email?.isEmpty, _ = name?.isEmpty {
                return true
            }
            return false
        }
    }
    class var sharedInstance : UserManager {
        struct Singleton {
            static let instance = UserManager()
        }
        return Singleton.instance
    }
}