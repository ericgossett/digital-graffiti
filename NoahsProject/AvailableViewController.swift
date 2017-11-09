//
//  AvailableViewController.swift
//  NoahsProject
//
//  Created by ece on 11/7/17.
//  Copyright © 2017 Duke University. All rights reserved.
//

import Foundation
import UIKit

class AvailableViewController:UIViewController, UICollectionViewDataSource, UICollectionViewDelegate{
    
    @IBOutlet weak var availableCollectionView: UICollectionView!
    override func viewDidLoad() {
        availableCollectionView.delegate = self
        availableCollectionView.dataSource = self
        availableCollectionView.frame=self.view!.frame
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        availableCollectionView.reloadData()
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 100
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let  cell = collectionView.dequeueReusableCell(withReuseIdentifier: "availableCollectionCell", for: indexPath) as! AvailableCollectionCell
        cell.cellLab.text="Artist "+String(indexPath.item)
        let isSubbed = subArr.contains("Artist "+String(indexPath.item))
        cell.cellCheck.isHidden = !isSubbed
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! AvailableCollectionCell
        cell.cellCheck.isHidden = false
        cell.cellLab.isHidden = false
        if !subArr.contains(cell.cellLab.text!){
            subArr.append(cell.cellLab.text!)
        }
        print(subArr)
    }
    private func collectionView(collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, atIndexPath indexPath: IndexPath) {
        
    }
}
