import UIKit
import GoogleMaps
import CoreMotion

class CameraViewController: ViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    let locationManager = CLLocationManager()
    var lat = 0.0
    var lng = 0.0
    @IBOutlet weak var accelerometerDataLabel: UILabel!
    var accelerometer = CMMotionManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initMenuButton()
        
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
        self.view.alpha = 0
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.camera
        imagePicker.showsCameraControls = true
        self.present(imagePicker, animated: false, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        self.view.alpha = 1
        let imageFromPC = info[UIImagePickerControllerOriginalImage] as! UIImage
        imageView.image = imageFromPC
        self.dismiss(animated: true, completion: nil)
        
        accel()
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.openPrevious(false)
        self.dismiss(animated: true, completion: nil)
    }
    
    func accel() {
        guard accelerometer.isAccelerometerAvailable else {
            return
        }
        accelerometer.startAccelerometerUpdates(to: .main) { (data, error) in
            guard let data = data, error == nil else {
                return
            }
            self.accelerometerDataLabel.text = "(" + String(data.acceleration.x) + ", " + String(data.acceleration.y) + ", " + String(data.acceleration.z) + ")"
        }
    }
    
    @IBAction func saveOnMapBtnClick(_ sender: Any) {
        var allPhotos : [Photo] = []
        if let photos = UserDefaults.standard.object(forKey: "photos") as? Data {
            allPhotos = NSKeyedUnarchiver.unarchiveObject(with: photos) as! [Photo]
        }
        let newPhoto = Photo(img: imageView.image!, lat: lat, lng: lng)
        allPhotos.append(newPhoto)
        let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: allPhotos)
        UserDefaults.standard.set(encodedData, forKey: "photos")
        UserDefaults.standard.synchronize()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        locationManager.delegate = nil
        lat = locValue.latitude
        lng = locValue.longitude
    }
}
