import Foundation
import GoogleMaps

class LocationManager {
    
    var location : CLLocationCoordinate2D?
    
    init() {
        location = nil
    }
    
    class var sharedInstance : LocationManager {
        struct Singleton {
            static let singleton = LocationManager()
        }
        return Singleton.singleton
    }
}