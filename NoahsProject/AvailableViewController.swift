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
    var firstLoad=true
    override func viewDidLoad() {
        super.viewDidLoad()
        print("here")
        print("now here")
        availableCollectionView.delegate = self
        availableCollectionView.dataSource = self
        availableCollectionView.frame=self.view!.frame
        
        //        if firstLoad{
        //            myClient.fetchUserList { (returnedArtists) in
        //                for curArtist in returnedArtists{
        //                    if !artistInAvailable(checkArtist: curArtist){
        //                        myClient.fetchTag(username: curArtist.username, completion: {(imgData) in
        //                            var curLoadArtist=loadedArtist(artist: curArtist, artistImage:UIImage(data: imgData)!)
        //                            availableArtists.append(curLoadArtist)
        //                        })
        //                    }
        //                }
        //                self.availableCollectionView.reloadData()
        //            }
        //        }
        //        self.firstLoad=false
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print("view appeared")
        if self.firstLoad{myClient.fetchUserList { (returnedArtists) in
            for curArtist in returnedArtists{
                if !artistInAvailable(checkArtist: curArtist){
                    myClient.fetchTag(username: curArtist.username, completion: {(imgData) in
                        let curLoadArtist=loadedArtist(artist: curArtist, artistImage:UIImage(data: imgData)!)
                        if !artistInAvailable(checkArtist: curArtist){ availableArtists.append(curLoadArtist)}
                        self.availableCollectionView.reloadData()
                    })
                }
            }
            
            }}
        self.firstLoad=false
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        availableCollectionView.reloadData()
        myClient.fetchUserList { (returnedArtists) in
            for curArtist in returnedArtists{
                if !artistInAvailable(checkArtist: curArtist){
                    myClient.fetchTag(username: curArtist.username, completion: {(imgData) in
                        let curLoadArtist=loadedArtist(artist: curArtist, artistImage:UIImage(data: imgData)!)
                        if !artistInAvailable(checkArtist: curArtist){ availableArtists.append(curLoadArtist)}
                        self.availableCollectionView.reloadData()
                    })
                }
            }
            
        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(availableArtists.count)
        return availableArtists.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let  cell = collectionView.dequeueReusableCell(withReuseIdentifier: "availableCollectionCell", for: indexPath) as! AvailableCollectionCell
        let curArtist = availableArtists[indexPath.item]
        cell.cellLab.text=curArtist.artist.username
        cell.cellIm.image=curArtist.artistImage
        let isSubbed = artistInSubscribed(checkArtist: curArtist.artist)
        cell.cellCheck.isHidden = !isSubbed
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! AvailableCollectionCell
        cell.cellCheck.isHidden = false
        cell.cellLab.isHidden = false
        let curLoadArtist = availableArtists[indexPath.item]
        let curArtist = curLoadArtist.artist
        if !artistInSubscribed(checkArtist: curArtist){
            try! subscriptions.subscribeToArtist(username: curArtist.username) // TODO handle catchs
            subscribedArtists.append(curLoadArtist)
            print(subscriptions.subscriptions())
        }
    }
    private func collectionView(collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, atIndexPath indexPath: IndexPath) {
        
    }
}

