//
//  HttpRetriever.swift
//  YelpForBathrooms
//
//  Created by Mitchell Waldman on 11/24/15.
//  Copyright © 2015 Five Letter. All rights reserved.
//

import Foundation
import SwiftHTTP
import Alamofire

class HttpRetriever : IHttpRetriever {
    func makeRetrievalRequest(url: String, options: Dictionary<String, AnyObject>, success: ((data: NSData!) ->Void)) {
        print(options)
        Alamofire.request(.POST, url, parameters: options, encoding: .JSON).responseJSON() {
            (response) in
            print(response)
            success(data: response.data!)
        }
    }
}