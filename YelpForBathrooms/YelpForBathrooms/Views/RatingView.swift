//
//  RateView.swift
//  YelpForBathrooms
//
//  Created by Vince Ly on 11/23/15.
//  Copyright © 2015 Five Letter. All rights reserved.
//

import UIKit

// MARK: DELEGATE

protocol RatingViewDelegate{
    func ratingView(rateView: RatingView, ratingDidChange: Int)
}

class RatingView: UIView {
// MARK: PROPERTIES
    
    var delegate: RatingViewDelegate?
    var notSelectedImages: [UIImage]? {
        didSet{
            // Check if images were set
            if let images = self.notSelectedImages{
                // remove current views in imageViews property
                for i in 0..<self.imageViews.count{
                    let imageView = self.imageViews[i]
                    imageView.removeFromSuperview()
                }
                self.imageViews.removeAll()
                
                
                for image in images{
                    // Create and setup image view
                    let newImageView = UIImageView(image: image)
                    newImageView.contentMode = .ScaleAspectFit
                    // Add image view to respective places
                    self.imageViews.append(newImageView)
                    self.addSubview(newImageView)
                }
                self.setNeedsLayout()
            }
        }
    }
    var fullSelectedImage: [UIImage]?
    var imageViews = [UIImageView]()
    var rating: Int? = 0 {
        didSet{
            refresh(oldValue!)
        }
    }
    var editable: Bool? = true
    var midMargin: CGFloat = 5 {
        didSet{
            self.layoutSubviews()
        }
    }
    var minImageSize: CGSize = CGSize(width: 5, height: 5)
    
// MARK: INITIALIZERS
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
// MARK: RATING VIEW FUNCTIONS
    
    func refresh(oldValue: Int){
        if oldValue != 0{
            let oldImageView = imageViews[oldValue - 1]
            oldImageView.image = notSelectedImages![oldValue - 1]
        }
        let newImageView = imageViews[rating! - 1]
        newImageView.image = fullSelectedImage![rating! - 1]
    }
    
// MARK: LAYOUT
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if notSelectedImages == nil{
            return
        }
        let imageCount = imageViews.count
        
        let photo = imageViews[0]
        let widthHeightRatio = photo.frame.width/photo.frame.height
        
        let desiredImageWidth = (self.frame.size.width - (CGFloat(imageCount)*midMargin))/CGFloat(imageCount)
        let imageWidth = max(minImageSize.height*widthHeightRatio, desiredImageWidth)
        let imageHeight = max(minImageSize.height, self.frame.size.height)

        for i in 0..<(imageViews.count){
            let imageView: UIImageView = self.imageViews[i]
            let imageFrame = CGRect(x: 5 + CGFloat(i)*(midMargin + imageWidth), y: 0, width: imageWidth, height: imageHeight)
            imageView.frame = imageFrame
        }
    }
    
// MARK: HANDLE TOUCH
    
    func handleTouchAtLocation(touchLocation: CGPoint){
        if !editable!{
            return
        }
        var newRating = 0
        for i in 0..<imageViews.count{
            if let imageView:UIImageView = imageViews[i]{
                if (touchLocation.x > imageView.frame.origin.x){
                    newRating = i + 1
                } else{
                    break
                }
            }
        }
        rating = max(min(newRating, 5), 1)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first!
        let touchLocation = touch.locationInView(self)
        handleTouchAtLocation(touchLocation)
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first!
        let touchLocation = touch.locationInView(self)
        handleTouchAtLocation(touchLocation)
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        delegate?.ratingView(self, ratingDidChange: self.rating!)
    }
}
