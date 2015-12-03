//
//  DetailsHeaderView.swift
//  YelpForBathrooms
//
//  Created by Vince Ly on 12/2/15.
//  Copyright © 2015 Five Letter. All rights reserved.
//

import UIKit
class FlagsCellModel{
    //  MARK: - MODEL PROPERTIES
    var title : String
    var headerImage : UIImage!
    var rating : Double
    
    //  MARK: - INITIALIZERS
    init(){
        title = "Default Title"
        rating = 0.0
        headerImage = UIImage(named: "DefaultHeaderImage")
    }
    
    init(title: String, rating: Double, headerImage : UIImage?){
        self.title = title
        self.rating = rating
        
        if let image = headerImage{
            self.headerImage = image
        } else{
            self.headerImage = UIImage(named: "DefaultHeaderImage")
        }
    }
}
class FlagsCell: YLTableViewCell{

    override func setModel(model: AnyObject?) {
        self.textLabel?.text = model as? String
    }
}
