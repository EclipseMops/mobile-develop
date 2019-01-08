import UIKit

class LeftMenuViewController: ViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var menuCollectionView: UICollectionView!
    var menuElements : [MenuElement] = []
    static var navController: UINavigationController? = UINavigationController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createMenuItems()
        menuCollectionView.delegate = self
        menuCollectionView.dataSource = self
    }
    
    func createMenuItems() {
        menuElements.append(MenuElement(title: "Список репозиториев", target: MainViewController.self))
        menuElements.append(MenuElement(title: "Об устройстве", target: AboutPhoneViewController.self))
        menuElements.append(MenuElement(title: "Сделать фото", target: CameraViewController.self))
        menuElements.append(MenuElement(title: "Карта", target: MapViewController.self))
        menuElements.append(MenuElement(title: "Список контактов", target: ContactsViewController.self))
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return menuElements.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = menuCollectionView.dequeueReusableCell(withReuseIdentifier: "myCell", for: indexPath) as! MenuCollectionViewCell
        cell.titleLabel.text = menuElements[indexPath.item].title
        cell.navBtn.tag = indexPath.item
        cell.navBtn.addTarget(self, action: #selector(openMenuElement), for: .touchUpInside)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 50)
    }
    
    @objc func openMenuElement(_ sender: Any) {
        let button = sender as! UIButton
        self.openPage(id: menuElements[button.tag].target!)
    }
    
    
    func openPage(id: ViewController.Type) {
        let page = self.storyboard?.instantiateViewController(withIdentifier: id.className)
        let trans = CATransition()
        trans.duration = 0.3
        trans.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        trans.type = kCATransitionMoveIn
        trans.subtype = kCATransitionFromLeft
        LeftMenuViewController.navController!.view.layer.add(trans, forKey: nil)
        LeftMenuViewController.navController?.pushViewController(page!, animated: false)
        dismiss(animated: true, completion: nil)
    }
    
}

class MenuElement {
    var title : String? = nil
    var target : ViewController.Type? = nil
    
    init(title: String, target: ViewController.Type) {
        self.title = title
        self.target = target
    }
}

class MenuCollectionViewCell : UICollectionViewCell{
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var navBtn: UIButton!
    
}
