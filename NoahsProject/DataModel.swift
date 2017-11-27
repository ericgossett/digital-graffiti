import Foundation
import UIKit
class loadedArtist: NSObject, NSCoding {
    var artist : Artist
    var artistImage=UIImage()
    init(_ inputArtist: Artist,_ inputImage: UIImage){
        self.artist=inputArtist
        self.artistImage=inputImage
    }
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.artist, forKey: "artist")
        //Convert artist image to string
        let artistImageData=UIImagePNGRepresentation(self.artistImage)
        let strBase64 = artistImageData!.base64EncodedString(options: .lineLength64Characters)
        aCoder.encode(strBase64, forKey:"artistImage")
        print("encoded artist")
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let curArtist = aDecoder.decodeObject(forKey: "artist") as! Artist
        let artistImageStr = aDecoder.decodeObject(forKey: "artistImage") as! String
        let dataDecoded:NSData = NSData(base64Encoded: artistImageStr, options: NSData.Base64DecodingOptions(rawValue: 0))!
        let decodedimage:UIImage = UIImage(data: dataDecoded as Data)!
        self.init(curArtist, decodedimage)
        print("decoded Artist")
    }
    
    static func saveArtistListData(_ artistList: [loadedArtist], _ fileName: String) -> Bool {
        let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
        let ArchiveURL = DocumentsDirectory.appendingPathComponent(fileName)
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(artistList, toFile: ArchiveURL.path)
        if !isSuccessfulSave {
            print("Failed to save info")
            return false
        } else {
            print("Saved")
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
func artistInAvailable(checkArtist: Artist)->Bool{
    for curArtist in availableArtists{
        if curArtist.artist.username==checkArtist.username{
            return true
        }
    }
    return false
}
func artistInSubscribed(checkArtist: Artist)->Bool{
    for curArtist in subscribedArtists{
        if curArtist.artist.username==checkArtist.username{
            return true
        }
    }
//    for piece in subscriptions.subscriptions() {
//        if piece.username == checkArtist.username {
//            return true
//        }
//    }
    return false
}

