import Foundation
import UIKit
class loadedArtist: NSObject, NSCoding { //loadedArtist consists of artist information and their corresponding tag which was loaded from the database. See availableArtists and subscribedArtist for example uses.
    var artist : Artist
    var artistImage=UIImage()
    init(_ inputArtist: Artist,_ inputImage: UIImage){
        self.artist=inputArtist
        self.artistImage=inputImage
    }
    //These functions are for making the object compatible with NSCoding
    func encode(with aCoder: NSCoder) { //decoder for loaded Artist. Need to encode each field that described an artist seperately as artist does not follow NSCoding protocol.
        aCoder.encode(self.artist.username, forKey: "artistUsername")
        aCoder.encode(self.artist.tag.name, forKey:"artistTagName")
        aCoder.encode(self.artist.tag.url, forKey:"artistTagURL")
        aCoder.encode(self.artist.model.name, forKey:"artistModelName")
        aCoder.encode(self.artist.model.url, forKey:"artistModelURL")
        aCoder.encode(self.artist.texture.name, forKey:"artistTextureName")
        aCoder.encode(self.artist.texture.url, forKey:"artistTextureURL")
        //Convert artist image to string
        let imageData = UIImageJPEGRepresentation(self.artistImage, 0.9)!
        let base64String = imageData.base64EncodedString(options: NSData.Base64EncodingOptions.lineLength64Characters)
        aCoder.encode(base64String, forKey:"artistImage")
    }
    
    required convenience init?(coder aDecoder: NSCoder) { //decoder for loaded Artist. Need to decode each field that described an artist seperately as artist does not follow NSCoding protocol. Then create an artist based on these fields.
        let curArtistUserName = aDecoder.decodeObject(forKey: "artistUsername") as! String
        let curArtistTagName = aDecoder.decodeObject( forKey:"artistTagName") as! String
        let curArtistTagURL = aDecoder.decodeObject( forKey:"artistTagURL") as! URL
        let curArtistModelName = aDecoder.decodeObject( forKey:"artistModelName") as! String
        let curArtistModelURL = aDecoder.decodeObject( forKey:"artistModelURL") as! URL
        let curArtistTextureName = aDecoder.decodeObject( forKey:"artistTextureName") as! String
        let curArtistTextureURL = aDecoder.decodeObject( forKey:"artistTextureURL") as! URL
        let artistImageStr = aDecoder.decodeObject(forKey: "artistImage") as! String
        let tagObject = Artist.FileObject(name: curArtistTagName, url: curArtistTagURL)
        let modelObject = Artist.FileObject(name: curArtistModelName, url: curArtistModelURL)
        let textureObject = Artist.FileObject(name: curArtistTextureName, url: curArtistTextureURL)
        let curArtist = Artist(username: curArtistUserName, tag: tagObject, model: modelObject, texture: textureObject)
        let dataDecoded:NSData = NSData(base64Encoded: artistImageStr, options: .ignoreUnknownCharacters)!
        let decodedimage:UIImage = UIImage(data: dataDecoded as Data)!
        self.init(curArtist, decodedimage)
    }
    
    static func saveArtistListData(_ artistList: [loadedArtist], _ fileName: String) -> Bool {
        let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
        let ArchiveURL = DocumentsDirectory.appendingPathComponent(fileName)
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(artistList, toFile: ArchiveURL.path)
        if !isSuccessfulSave {
            return false
        } else {
            return true
        }
    }
    
    static func loadArtistListData(_ fileName: String) -> [loadedArtist]? {
        let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
        let ArchiveURL = DocumentsDirectory.appendingPathComponent(fileName)
        return NSKeyedUnarchiver.unarchiveObject(withFile: ArchiveURL.path) as? [loadedArtist]
    }
    
    
    
}

var myClient=APIClient()
var subscriptions = SubscriptionManager()
var availableArtists = [loadedArtist]()
var subscribedArtists = [loadedArtist]()
func artistInAvailable(checkArtist: Artist)->Bool{ //This function checks to see if an artist is in the available list
    for curArtist in availableArtists{
        if curArtist.artist.username==checkArtist.username{
            return true
        }
    }
    return false
}
func artistInSubscribed(checkArtist: Artist)->Bool{ //This function checks to see if an artist is in the subscribed list
    for curArtist in subscribedArtists{
        if curArtist.artist.username==checkArtist.username{
            return true
        }
    }
    return false
}
let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
let ArchiveURLSubbed = DocumentsDirectory.appendingPathComponent("subbedDatabase") //Archive used for saving subscription list

func saveSubscribed() { //function for saving subscribedArtists list
    let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(subscribedArtists, toFile: ArchiveURLSubbed.path)
    
    if isSuccessfulSave{
        // print("sub save succeeded")
    }else{
        // print("sub save failed")
    }

}

func loadSubscribed(){ //function for loading subscribedArtists list
    subscribedArtists=(NSKeyedUnarchiver.unarchiveObject(withFile: ArchiveURLSubbed.path) as? [loadedArtist])!
}

