import UIKit
import SideMenu

class ViewController: UIViewController {
    
    var loadingLabel = UILabel()
    var countLoadings = 0
    
    override func viewDidLoad() {
        initLoadingView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    static var className: String {
        return String(describing: self)
    }
    
    func initMenuButton() {
        createNavigationButton(action: #selector(menuButtonClick), imgName: "menu", padding: -10)
        initLeftMenu()
    }
    
    func initLoadingView() {
        loadingLabel = UILabel(frame: CGRect(x: self.view.frame.width / 2 - 100, y: self.view.frame.height / 2 - 15, width: 200, height: 30))
        loadingLabel.backgroundColor = .red
        loadingLabel.text = "Загрузка... ;)"
        loadingLabel.textAlignment = .center
        self.view.addSubview(loadingLabel)
        loadingLabel.isHidden = true
    }
    
    func showLoadingView() {
        print("show")
        countLoadings += 1
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .microseconds(0), execute: {
            if(self.countLoadings != 0) {
                self.loadingLabel.isHidden = false
            }
        })
    }
    
    func hideLoadingView() {
        countLoadings -= 1
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .microseconds(0), execute: {
            if(self.countLoadings == 0) {
                self.loadingLabel.isHidden = true
            }
        })
    }
    
    @objc func menuButtonClick() {
        present(SideMenuManager.default.menuLeftNavigationController!, animated: true, completion: nil)
    }
    
    @objc func backButtonClick() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func initLeftMenu() {
        if(SideMenuManager.default.menuLeftNavigationController == nil) {
            let menuLeftNavigationController = UISideMenuNavigationController(rootViewController: (self.storyboard?.instantiateViewController(withIdentifier: LeftMenuViewController.className))!)
            SideMenuManager.default.menuLeftNavigationController = menuLeftNavigationController
        }

        SideMenuManager.defaultManager.menuPresentMode = .menuSlideIn
        SideMenuManager.defaultManager.menuFadeStatusBar = false
        SideMenuManager.defaultManager.menuWidth = 300
        SideMenuManager.defaultManager.menuShadowRadius = 15
        
        SideMenuManager.defaultManager.menuEnableSwipeGestures = true
        
        if(self.navigationController != nil) {
            SideMenuManager.default.menuAddPanGestureToPresent(toView: self.navigationController!.navigationBar)
            SideMenuManager.default.menuAddScreenEdgePanGesturesToPresent(toView: self.navigationController!.view)
        }
    }
    
    func openPage(id: ViewController.Type, animated: Bool? = true){
        let page = self.storyboard?.instantiateViewController(withIdentifier: id.className) as! ViewController
        self.navigationController?.pushViewController(page as UIViewController, animated: animated!)
    }
    
    func openPrevious(_ animated : Bool? = true) {
        self.navigationController?.popViewController(animated: animated!)
    }
    
    func createNavigationButton(action: Selector, imgName: String, padding: Int) {
        let button = UIBarButtonItem(title: "", style: .plain, target: self, action: action)
        button.tintColor = UIColor.black
        button.imageInsets = UIEdgeInsetsMake(0, CGFloat(padding), 0, 0)
        button.image = UIImage(named: imgName)
        self.navigationItem.leftBarButtonItem = button
    }
    
}
