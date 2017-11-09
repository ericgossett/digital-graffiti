//
//  UIAvailableCollectionView.swift
//  NoahsProject
//
//  Created by ece on 11/6/17.
//  Copyright © 2017 Duke University. All rights reserved.
//

import Foundation
import UIKit
class UIAvailableCollectionViewController:UICollectionViewController{
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        
        var cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath as IndexPath) as! availableCell
        cell.backgroundColor = .black
        
        
        return cell
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return 4
    }
    
    func collectionView(collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        return CGSize(width: 100  , height: 50)
        
    }
}

class availableCell:UICollectionViewCell{
    
}
