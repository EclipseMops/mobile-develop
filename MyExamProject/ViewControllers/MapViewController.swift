import UIKit
import GoogleMaps

class MapViewController: ViewController, CLLocationManagerDelegate, GMSMapViewDelegate  {
    
    @IBOutlet weak var mapView: GMSMapView!
    private let locationManager = CLLocationManager()
    var markers : [Marker] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initMenuButton()
        let camera: GMSCameraPosition = GMSCameraPosition.camera(withLatitude: 55.753960, longitude: 37.620393, zoom: 17.0)
        mapView.camera = camera
        mapView.delegate = self
        
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
        addImages()
        buildPath()
    }
    
    var figurePoints : [CLLocationCoordinate2D] = []
    
    func buildPath() {
        JsonAction.newPost(address: "https://maps.googleapis.com/maps/api/directions/json?origin=Россия+Москва+Метро+Преображенская+Площадь&destination=Россия+Москва+МГУПИ&key=AIzaSyBg6doK692GJMuB9RAmjvwOa8ng8xG8bWs", args: [:], {response in
            self.figurePoints.removeAll()
            let json = response?.value as! [String : Any]
            if(json["routes"] == nil || json["routes"] as? [Any] == nil || (json["routes"] as? [Any])?.count == 0) {
                let alert = UIAlertController(title: "Ошибка", message: "Лимит запросов к АПИ или путь не найден.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ок", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            }
            
            let routes = (json["routes"] as! [Any])[0] as! [String : Any]
            let overview_polyline = routes["overview_polyline"] as! [String : Any]
            let points = overview_polyline["points"] as! String
            let path = GMSPath.init(fromEncodedPath: points)
            for i in 0..<Int(path!.count()) {
                self.figurePoints.append(path!.coordinate(at: UInt(i)))
            }
            self.drawRectange()
        })
    }
    
    var rectangle : GMSPolyline? = nil
    func drawRectange(){
        if(rectangle != nil) {
            rectangle!.map = nil
        }
        let path = GMSMutablePath()
        for figurePoint in figurePoints {
            path.add(figurePoint)
        }
        rectangle = GMSPolyline(path: path)
        rectangle?.strokeWidth = 5
        rectangle?.strokeColor = UIColor(red: 255 / 255.0, green: 192 / 255.0, blue: 203 / 255.0, alpha: 1)
        rectangle!.map = mapView
    }
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        var size = Int(((position.zoom - 12) * Float(4)) * 6)
        if(position.zoom < 12) {
            size = 0
        }
        for marker in markers {
            marker.marker?.iconView?.frame = CGRect(x: 0, y: 0, width: Int(Float(size)), height: Int(Float(size)))
            marker.photoView?.frame = CGRect(x: 0, y: 0, width: Int(Float(size)), height: Int(Float(size)))
            marker.marker?.iconView?.layer.cornerRadius = (marker.marker?.iconView?.frame.size.width)! / 2
            marker.marker?.iconView?.clipsToBounds = true
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
        locationManager.stopUpdatingLocation()
    }
    
    func addImages() {
        if let photos = UserDefaults.standard.object(forKey: "photos") as? Data {
            let allPhotos = NSKeyedUnarchiver.unarchiveObject(with: photos) as! [Photo]
            print(allPhotos.count)
            for photo in allPhotos {
                let marker = Marker()
                marker.latitude = photo.lat
                marker.longitude = photo.lng
                marker.photo = photo.img
                marker.createMarker(mapView: self.mapView)
                self.markers.append(marker)
            }
        }
    }
    
}
