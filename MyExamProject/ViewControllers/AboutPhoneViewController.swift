import UIKit

class AboutPhoneViewController: ViewController {
    
    @IBOutlet weak var aboutPhoneTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initMenuButton()
        insertInfoAboutPhone()
    }
    
    func insertInfoAboutPhone() {
        printInfo(false)
        printInfo(true)
    }
    
    func printInfo(_ withIp: Bool) {
        var info : [String] = []
        info.append("Система: " + String(UIDevice().systemName))
        info.append("Версия системы: " + String(UIDevice().systemVersion))
        info.append("Модель: " + String(UIDevice.current.modelName))
        info.append("UUID: " + (UIDevice.current.identifierForVendor?.uuidString)!)
        if(withIp) {
            Instruments.getIPAddress({response in
                if let ip = response {
                    info.append("IP: " + ip)
                    self.aboutPhoneTextView.text = ""
                    for str in info {
                        self.aboutPhoneTextView.text = self.aboutPhoneTextView.text + "\n" + str
                    }
                }
            })
        } else {
            info.append("IP: -")
            aboutPhoneTextView.text = ""
            for str in info {
                self.aboutPhoneTextView.text = self.aboutPhoneTextView.text + "\n" + str
            }
        }
        
    }
    
}
