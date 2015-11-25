//
//  IBathroomDetailRetriever.swift
//  YelpForBathrooms
//
//  Created by Mitchell Waldman on 11/24/15.
//  Copyright © 2015 Five Letter. All rights reserved.
//

import Foundation

protocol IBathroomDetailRetriever {
    func GetBathroomDetail(bathroomId: Int, completion: (BathroomDetail? -> Void))
}