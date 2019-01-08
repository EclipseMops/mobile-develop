import UIKit
import GoogleMaps

class Marker {
    var latitude : Double = -1
    var longitude : Double = -1
    var marker : GMSMarker? = nil
    var photo : UIImage? = nil
    var photoView : UIImageView? = nil
    
    func createMarker(mapView: GMSMapView){
        let position = CLLocationCoordinate2D(latitude: CLLocationDegrees(latitude), longitude: CLLocationDegrees(longitude))
        let marker = GMSMarker(position: position)
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        let img = UIImageView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        img.image = photo
        photoView = img
        view.addSubview(img)
        marker.iconView = view
        marker.map = mapView
        self.marker = marker
    }
}

