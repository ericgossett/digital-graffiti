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
    override func viewDidLoad() {
        super.viewDidLoad()
        let fileManager = FileManager.default
        if self.loadMe{if fileManager.fileExists(atPath: ArchiveURLSubbed.path) {
                loadSubscribed()
                self.loadMe=false
        } else {
            print("FILE NOT AVAILABLE")
            }}
        availableCollectionView.delegate = self
        availableCollectionView.dataSource = self
        availableCollectionView.frame=self.view!.frame
        // availableCollectionView.bounds = availableCollectionView.frame.insetBy(dx: 10.0, dy: 10.0)
        
        
        // This will define a responsive layout (or at least attempt to)
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        let width = availableCollectionView.bounds.width
        
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 20, right: 10)
        layout.itemSize = CGSize(width: width / 3 - 20, height: 180)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 20
        availableCollectionView!.collectionViewLayout = layout
        
        
        // availableCollectionView!.backgroundColor = UIColor.green
        
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
        if self.firstLoad{
            fetchFromServer()
            /*
            myClient.testConnection { connected in
                if connected {
                    myClient.fetchUserList { (returnedArtists) in
                        for curArtist in returnedArtists{
                            if !artistInAvailable(checkArtist: curArtist){
                                myClient.fetchTag(username: curArtist.username, completion: {(imgData) in
                                    let curLoadArtist=loadedArtist(curArtist, UIImage(data: imgData)!)
                                    if !artistInAvailable(checkArtist: curArtist){ availableArtists.append(curLoadArtist)}
                                    self.availableCollectionView.reloadData()
                                })
                            }
                        }
                    }
                } else {
                    let alertController = UIAlertController(title: "Connection Error", message: "Unable to reach server, please check your wifi. If your wifi is working email Eric at ericmgossett@gmail.com and tell him to get his server in check!", preferredStyle: .alert)
                    let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alertController.addAction(OKAction)
                    self.present(alertController, animated: true, completion: nil)
                }
            }
             */
        }
        self.firstLoad=false
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        availableCollectionView.reloadData()
        fetchFromServer()
        /*
        myClient.testConnection { connected in
            if connected {
                myClient.fetchUserList { (returnedArtists) in
                    for curArtist in returnedArtists{
                        if !artistInAvailable(checkArtist: curArtist){
                            myClient.fetchTag(username: curArtist.username, completion: {(imgData) in
                                let curLoadArtist=loadedArtist(curArtist, UIImage(data: imgData)!)
                                if !artistInAvailable(checkArtist: curArtist){ availableArtists.append(curLoadArtist)}
                                self.availableCollectionView.reloadData()
                            })
                        }
                    }
                }
            } else {
                let alertController = UIAlertController(title: "Connection Error", message: "Unable to reach server, please check your wifi. If your wifi is working email Eric at ericmgossett@gmail.com and tell him to get his server in check!", preferredStyle: .alert)
                let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(OKAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }
       */
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(availableArtists.count)
        return availableArtists.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let  cell = collectionView.dequeueReusableCell(withReuseIdentifier: "availableCollectionCell", for: indexPath) as! AvailableCollectionCell
        let curArtist = availableArtists[indexPath.item]
        cell.cellLab.text=curArtist.artist.username
        print(curArtist.artist.username)
        cell.cellIm.image=curArtist.artistImage
        cell.cellIm.contentMode = .scaleAspectFit
        let isSubbed = artistInSubscribed(checkArtist: curArtist.artist)
        cell.cellCheck.isHidden = !isSubbed
        
        // cell.bounds = cell.frame.insetBy(dx: 10.0, dy: 10.0) // Some hack way to get a constant padding because collection view changes the padding size.
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
        //if cell.cellCheck.isHidden{//Just in case other ops are too slow
        cell.cellCheck.isHidden = false
        
        let curLoadArtist = availableArtists[indexPath.item]
        let curArtist = curLoadArtist.artist
        if !artistInSubscribed(checkArtist: curArtist){
            subscribedArtists.append(curLoadArtist)
            saveSubscribed()
            do{try subscriptions.subscribeToArtist(username: curArtist.username) }
            catch{
            }// TODO handle catchs
            print(subscriptions.subscriptions())
            }
    }

    /*
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width/3.0 - 20
        
        return CGSize(width: width, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0,10,20,10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    */
    
    private func collectionView(collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, atIndexPath indexPath: IndexPath) {
        
    }
}


extension AvailableViewController {
    
    func fetchFromServer() {
        myClient.testConnection { connected in
            if connected {
                myClient.fetchUserList { (returnedArtists) in
                    for curArtist in returnedArtists{
                        if !artistInAvailable(checkArtist: curArtist){
                            myClient.fetchTag(username: curArtist.username, completion: {(imgData) in
                                let curLoadArtist=loadedArtist(curArtist, UIImage(data: imgData)!)
                                if !artistInAvailable(checkArtist: curArtist){ availableArtists.append(curLoadArtist)}
                                self.availableCollectionView.reloadData()
                            })
                        }
                    }
                }
            } else {
                let alertController = UIAlertController(title: "Connection Error", message: "Unable to reach server, please check your wifi. If your wifi is working email Eric at ericmgossett@gmail.com and tell him to get his server in check!", preferredStyle: .alert)
                let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(OKAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
}
