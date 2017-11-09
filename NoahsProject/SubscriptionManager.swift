//
//  SubscriptionManager.swift
//  NoahsProject
//
//  Created by egossett on 11/6/17.
//  Copyright © 2017 Duke University. All rights reserved.
//

import Foundation

enum SubscriptionManagerError: Error {
    case userNotFound
    case alreadySubscribed
}


class Piece: NSObject, NSCoding {
    struct EncodeKeys {
        static let username = "username"
        static let tag = "tag"
        static let model = "model"
        static let texture = "texture"
    }
    let username: String
    let tag: URL
    let model: URL
    let texture: URL
    
    init(username: String, tag: URL, model: URL, texture: URL) {
        self.username = username
        self.tag = tag
        self.model = model
        self.texture = texture
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(username, forKey: EncodeKeys.username)
        aCoder.encode(tag, forKey: EncodeKeys.tag)
        aCoder.encode(model, forKey: EncodeKeys.model)
        aCoder.encode(texture, forKey: EncodeKeys.texture)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let username = aDecoder.decodeObject(forKey: EncodeKeys.username) as! String
        let tag = aDecoder.decodeObject(forKey: EncodeKeys.tag) as! URL
        let model = aDecoder.decodeObject(forKey: EncodeKeys.model) as! URL
        let texture = aDecoder.decodeObject(forKey: EncodeKeys.texture) as! URL
        self.init(username: username, tag: tag, model: model, texture: texture)
    }
    
}

class SubscriptionManager {

    private var _pieces = [Piece]()
    private let api = APIClient()
    private let modelManager = ModelManager()
    var tagsURL: URL
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("Subscriptions")

    
    init() {
        let fileManager = FileManager.default
        let documentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
        tagsURL = documentsDirectory.appendingPathComponent("Tags")
        if !fileManager.fileExists(atPath: tagsURL.path){
            do {
                try fileManager.createDirectory(atPath: tagsURL.path, withIntermediateDirectories: true, attributes: nil)
            } catch {
                NSLog("Couldn't create document directory")
            }
        }
        if let diskData  = SubscriptionManager.loadFromDisk() {
            self._pieces = diskData
        }
    }
    
    func subscribeToArtist(username: String) throws {
        
        let isSubscribed = _pieces.contains(){ piece in
            if piece.username == username {
                return true
            } else {
                return false
            }
        }
        
        if isSubscribed {
            throw SubscriptionManagerError.alreadySubscribed
        }
        api.fetchTag(username: username) { (tagData) in
            do {
                let tagFile = self.tagsURL.appendingPathComponent("\(username)_tag.jpg")
                try tagData.write(to: tagFile)
                self.modelManager.saveAssets(username: username) { (modelFile, textureFile) in
                    self._pieces.append(
                        Piece(
                            username: username,
                            tag: tagFile,
                            model: modelFile,
                            texture: textureFile
                        )
                    )
                    let _ = SubscriptionManager.saveToDisk(self._pieces)
                }
            } catch {
                // TODO: Add some error
            }
        }
    }

    func unsubscribeToArtist(username: String) throws {
        let isSubscribed = _pieces.contains(){ piece in
            if piece.username == username {
                return true
            } else {
                return false
            }
        }
        
        if !isSubscribed {
            throw SubscriptionManagerError.userNotFound
        }
        
        let piece = _pieces.first(){$0.username == username}!
        
        do {
            try FileManager.default.removeItem(atPath: piece.tag.path)
            try modelManager.deleteAssets(username: username)
            self._pieces = self._pieces.filter(){$0.username != username}
            let _ = SubscriptionManager.saveToDisk(self._pieces)
        } catch {
            throw SubscriptionManagerError.userNotFound
        }
    }
    
    func subscriptions() -> [Piece] {
        return self._pieces
    }
    
    static func saveToDisk(_ data: [Piece]) -> Bool {
        return NSKeyedArchiver.archiveRootObject(data, toFile: SubscriptionManager.ArchiveURL.path)
    }
    
    static func loadFromDisk() -> [Piece]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: SubscriptionManager.ArchiveURL.path) as? [Piece]
    }
}
