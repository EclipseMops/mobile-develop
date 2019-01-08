import UIKit

class Photo: NSObject, NSCoding {

    var img: UIImage = UIImage()
    var lat = 0.0
    var lng = 0.0
    
    init(img: UIImage, lat: Double, lng: Double) {
        self.img = img
        self.lat = lat
        self.lng = lng
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let img = aDecoder.decodeObject(forKey: "img") as! UIImage
        let lat = aDecoder.decodeDouble(forKey: "lat")
        let lng = aDecoder.decodeDouble(forKey: "lng")
        self.init(img: img, lat: lat, lng: lng)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(img, forKey: "img")
        aCoder.encode(lat, forKey: "lat")
        aCoder.encode(lng, forKey: "lng")
    }
    
}
