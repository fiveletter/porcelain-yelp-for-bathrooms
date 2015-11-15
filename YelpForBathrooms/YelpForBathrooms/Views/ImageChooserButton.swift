//
//  ImageChooserButton.swift
//  YelpForBathrooms
//
//  Created by Vince Ly on 12/1/15.
//  Copyright © 2015 Five Letter. All rights reserved.
//

import UIKit

protocol ImageChooserButtonDelegate{
    func imageChooserButton(imageChooserButton: ImageChooserButton, buttonTapped: Bool)
}

class ImageChooserButton: UIView {
    
// MARK: - PROPERTIES
    var delegate: ImageChooserButtonDelegate?
    var hasImage: Bool = false
    
    var buttonCornerRadius:CGFloat?{
        didSet{
            setNeedsLayout()
        }
    }
    var buttonBackgroundColor: CGColor?{
        didSet{
            setNeedsLayout()
        }
    }
    var imageBorderColor: CGColor?{
        didSet{
            setNeedsLayout()
        }
    }
    var imageBorderWidth: CGFloat?{
        didSet{
            setNeedsLayout()
        }
    }

// MARK: - INTERNAL VIEWS
    
    private lazy var imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .ScaleAspectFit
        return iv
    }()
    
    private var button: UIButton = {
        let button = UIButton()
        button.layer.backgroundColor = UIColor.blueColor().CGColor
        return button
    }()
    
// MARK: - INITIALIZERS
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        sharedInitializiation()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sharedInitializiation()
    }

// MARK: - VIEW FUNCTIONS
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if (hasImage){
            button.setTitle("Change Photo", forState: .Normal)
            addSubview(imageView)
            imageView.frame = CGRect(x: 5, y: 0, width: frame.height , height: frame.height)
            button.frame = CGRect(x: 5 + imageView.frame.height + 5, y: 0, width: frame.width - (5 + imageView.frame.width + 5) - 5, height: frame.height)
        } else{
            button.setTitle("Add Photo", forState: .Normal)
            button.frame = CGRect(x: 5, y: 0, width: frame.width - 10, height: frame.height)
        }
        
        setupButton()
        setupImageView()
    }
}

// MARK: - PUBLIC PROPERTIES

extension ImageChooserButton{
    var buttonHeight: CGFloat {
        get{
             return button.frame.height
        }
    }
    
    var image: UIImage?{
        set (newImage){
            imageView.image = newImage
            self.hasImage = true
            self.setNeedsLayout()
        }
        get{
            return imageView.image
        }
    }
}

//MARK: - SETUP FUNCTIONS

extension ImageChooserButton{
    private func sharedInitializiation(){
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(button)
        button.addTarget(self, action: "buttonAction:", forControlEvents: .TouchUpInside)
        button.frame = CGRect(x: 5, y: 0, width: frame.width - 10, height: frame.height)
    }
    
    func setupImageView(){
        if let ibColor = imageBorderColor{
            imageView.layer.borderColor = ibColor
        }
        if let ibWidth = imageBorderWidth{
            imageView.layer.borderWidth = ibWidth
        }
    }
    
    func setupButton(){
        if let radius = buttonCornerRadius{
            button.layer.cornerRadius = radius
        }
        if let bgColor = buttonBackgroundColor{
            button.layer.backgroundColor = bgColor
        }
    }
    
    func buttonAction(sender:UIButton!){
        delegate?.imageChooserButton(self, buttonTapped: true)
    }
}