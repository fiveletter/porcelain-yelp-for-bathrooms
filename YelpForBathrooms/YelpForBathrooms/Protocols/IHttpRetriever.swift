//
//  IHttpRetriever.swift
//  YelpForBathrooms
//
//  Created by Mitchell Waldman on 11/28/15.
//  Copyright © 2015 Five Letter. All rights reserved.
//

import Foundation
protocol IHttpRetriever {
    func makeRetrievalRequest(url: String, options: Dictionary<String, AnyObject>, success: ((data: NSData!) -> Void))
}