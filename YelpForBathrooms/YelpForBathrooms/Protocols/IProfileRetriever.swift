//
//  IProfileRetriever.swift
//  YelpForBathrooms
//
//  Created by Mitchell Waldman on 11/28/15.
//  Copyright © 2015 Five Letter. All rights reserved.
//

import Foundation

protocol IProfileRetriever {
    func getProfileId(profileId: String, completion: (Int? -> Void))
    func createProfile(first: String, last: String, email: String, completion: (Int? -> Void))
    func authorize(completion: (Int? -> Void)?)
}