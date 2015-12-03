//
//  PhotosCell.swift
//  YelpForBathrooms
//
//  Created by Vince Ly on 12/3/15.
//  Copyright © 2015 Five Letter. All rights reserved.
//

import UIKit
import GoogleMaps

class PhotosCell: UITableViewCell{
    
    @IBOutlet var collectionView: UICollectionView!
    
    func setCollectionViewDataSourceDelegate<D: protocol<UICollectionViewDataSource, UICollectionViewDelegate>>(dataSourceDelegate: D, forRow row: Int){
        collectionView.delegate = dataSourceDelegate
        collectionView.dataSource = dataSourceDelegate
        collectionView.tag = row
        collectionView.reloadData()
    }
}