//
//  AvailableViewController.swift
//  NoahsProject
//
//  Created by ece on 11/7/17.
//  Copyright © 2017 Duke University. All rights reserved.
//

import Foundation
import UIKit

class AvailableViewController:UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    @IBOutlet weak var availableCollectionView: UICollectionView!
    var firstLoad=true
    var loadMe=true
    //This view controller controls the avaiable artists that will be displayed to the user in a collection view. This is populated based on data from our server. Users can subscribe to artist from the view (availableCollectionView) that this controls.
    override func viewDidLoad() {
        super.viewDidLoad()
        let fileManager = FileManager.default
        //This will load a subscription list if one exists
        if self.loadMe{if fileManager.fileExists(atPath: ArchiveURLSubbed.path) {
                loadSubscribed()
                self.loadMe=false //Will not load subscription list again
        } else {
            // print("FILE NOT AVAILABLE")
            }
        }
        availableCollectionView.delegate = self
        availableCollectionView.dataSource = self
        availableCollectionView.frame=self.view!.frame
        
        
        // This will define a responsive layout (or at least attempt to)
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        let width = availableCollectionView.bounds.width
        
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 20, right: 10)
        layout.itemSize = CGSize(width: width / 3 - 20, height: 180)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 20
        availableCollectionView!.collectionViewLayout = layout
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if self.firstLoad{
            fetchFromServer()
        }
        self.firstLoad=false
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        availableCollectionView.reloadData()
        fetchFromServer()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return availableArtists.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let  cell = collectionView.dequeueReusableCell(withReuseIdentifier: "availableCollectionCell", for: indexPath) as! AvailableCollectionCell
        let curArtist = availableArtists[indexPath.item]
        cell.cellLab.text=curArtist.artist.username
        cell.cellIm.image=curArtist.artistImage
        cell.cellIm.contentMode = .scaleAspectFit
        let isSubbed = artistInSubscribed(checkArtist: curArtist.artist) //If the artist is subscribed add a check
        cell.cellCheck.isHidden = !isSubbed
        
        cell.backgroundColor = UIColor.white
        cell.contentView.layer.cornerRadius = 2.0
        cell.contentView.layer.borderWidth = 1.0
        cell.contentView.layer.borderColor = UIColor.clear.cgColor
        cell.contentView.layer.masksToBounds = true
        
        cell.layer.shadowColor = UIColor.lightGray.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        cell.layer.shadowRadius = 2.0
        cell.layer.shadowOpacity = 1.0
        cell.layer.masksToBounds = false
        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: cell.contentView.layer.cornerRadius).cgPath
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! AvailableCollectionCell
        cell.cellCheck.isHidden = false
        
        let curLoadArtist = availableArtists[indexPath.item]
        let curArtist = curLoadArtist.artist
        if !artistInSubscribed(checkArtist: curArtist){
            subscribedArtists.append(curLoadArtist)
            saveSubscribed() //Add to subscribed artists and save
            do{try subscriptions.subscribeToArtist(username: curArtist.username) }
            catch{ } //Update subscription manager as well with new subscription. This will trigger downloading of model assets so they can be viewed in ARView.
        }
    }

    
    private func collectionView(collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, atIndexPath indexPath: IndexPath) {
        
    }
}


extension AvailableViewController {
    
    func fetchFromServer() { //This function populates availableArtists from data present on the server. This availableArtist list was added as we only wanted to add to the collection once the artist and their corresponding tag was loaded. The collection view is populated based on the availableArtists list.
        myClient.testConnection { connected in
            if connected {
                myClient.fetchUserList { (returnedArtists) in
                    for curArtist in returnedArtists{
                        if !artistInAvailable(checkArtist: curArtist){
                            myClient.fetchTag(username: curArtist.username, completion: {(imgData) in
                                let curLoadArtist=loadedArtist(curArtist, UIImage(data: imgData)!)
                                if !artistInAvailable(checkArtist: curArtist){ availableArtists.append(curLoadArtist)}
                                //Above added becuase of async nature of the fetch. Makes sure artist hasn't been added since fetching started to prevent duplicate artists in list.
                                self.availableCollectionView.reloadData()
                            })
                        }
                    }
                }
            } else { //This was added to prevent crashes in case of no server connect. Our application requires connection to our server to work properly.
                let alertController = UIAlertController(title: "Connection Error", message: "Unable to reach server, please check your wifi. If your wifi is working email Eric at ericmgossett@gmail.com and tell him to get his server in check!", preferredStyle: .alert)
                let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(OKAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
}
