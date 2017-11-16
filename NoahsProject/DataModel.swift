import Foundation
import UIKit
struct loadedArtist {
    var artist : Artist
    var artistImage=UIImage()
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
    /*
    for curArtist in subscribedArtists{
        if curArtist.artist.username==checkArtist.username{
            return true
        }
    }*/
    for piece in subscriptions.subscriptions() {
        if piece.username == checkArtist.username {
            return true
        }
    }
    return false
}

