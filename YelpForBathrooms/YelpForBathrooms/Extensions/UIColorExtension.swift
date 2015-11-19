//
//  HelperClass.swift
//  YelpForBathrooms
//
//  Created by Vince Ly on 11/18/15.
//  Copyright © 2015 Five Letter. All rights reserved.
//

import UIKit




extension UIColor {
    class func colorFromHexRGBValue(rgbHexColor: UInt32) -> UIColor{
        let redValue = CGFloat((rgbHexColor & 0xFF0000) >> 16)/255.0
        let greenValue = CGFloat((rgbHexColor & 0x00FF00) >> 8)/255.0
        let blueValue = CGFloat((rgbHexColor & 0x0000FF))/255.0
        
        return UIColor(red: redValue, green: greenValue, blue: blueValue, alpha: 1.0)
    }
}