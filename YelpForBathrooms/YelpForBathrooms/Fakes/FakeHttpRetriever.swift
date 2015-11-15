//
//  FakeHttpRetriever.swift
//  YelpForBathrooms
//
//  Created by Mitchell Waldman on 11/28/15.
//  Copyright © 2015 Five Letter. All rights reserved.
//

import Foundation
import SwiftyJSON

class FakeHttpRetriever : IHttpRetriever {
    func makeRetrievalRequest(url: String, options: Dictionary<String, AnyObject>, success: ((data: NSData!) -> Void)) {
        if let path = NSBundle.mainBundle().pathForResource("Info", ofType: "plist")
        {
            if let _ = NSDictionary(contentsOfFile: path)
            {
                if(url == UrlManager.BATHROOM_RETRIEVE)
                {
                    let filePath = NSBundle.mainBundle().pathForResource("bathroomRetrievalResponse",ofType:"json")
                    var readError:NSError?
                    do {
                        let data = try NSData(contentsOfFile:filePath!,
                            options: NSDataReadingOptions.DataReadingUncached)
                        success(data: data)
                    } catch let error as NSError {
                        readError = error
                    } catch {}
                }
            }
        
        }
    }
}