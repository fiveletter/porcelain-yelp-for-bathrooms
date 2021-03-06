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
            if let _ = email?.isEmpty, _ = name?.isEmpty, _ = userToken?.isEmpty {
                return true
            }
            return false
        }
    }
    var name : String?
    var userToken : String?
    var refreshToken: String?
    var profileId : Int?
    var profilePic: UIImage?
// MARK: - INITIALIZERS
    init(){
        profileId = 1
        userToken = "DEMO-AUTH-TOKEN"
    }
    
    init(userEmail : String?, userName: String?, id: Int?, token: String?) {
        email = userEmail
        name = userName
        profileId = id ?? 1
        userToken = token
    }

// MARK: - ACCESSORS
    func logOut() {
        email = nil
        name = nil
        profileId = nil
        userToken = nil
    }

// MARK: - SINGLETON
    class var sharedInstance : UserManager {
        struct Singleton {
            static let instance = UserManager()
        }
        return Singleton.instance
    }
}