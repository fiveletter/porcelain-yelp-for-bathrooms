//
//  File.swift
//  YelpForBathrooms
//
//  Created by Mitchell Waldman on 11/22/15.
//  Copyright © 2015 Five Letter. All rights reserved.
//

import Foundation

class UserManager {
// MARK: - PROPERTIES
    
    var email : String?
    var IsSignedIn : Bool {
        get {
            if let _ = email?.isEmpty, _ = name?.isEmpty {
                return true
            }
            return false
        }
    }
    var name : String?
    var userToken : String?
// MARK: - INITIALIZERS
    init(){
        NOOP("Does nothing")
    }
    
    init(userEmail : String?, userName: String?) {
        email = userEmail
        name = userName
    }

// MARK: - ACCESSORS
    func logOut() {
        email = nil
        name = nil
    }

// MARK: - SINGLETON
    class var sharedInstance : UserManager {
        struct Singleton {
            static let instance = UserManager()
        }
        return Singleton.instance
    }
}