import UIKit

class MainViewController: ViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
    
    var repositoryList : [Repository] = []
    @IBOutlet weak var repositoryCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LeftMenuViewController.navController = self.navigationController
        initMenuButton()
        getReposList()
        repositoryCollectionView.dataSource = self
        repositoryCollectionView.delegate = self
    }
    
    func getReposList() {
        Repository.controller.getList(view: self, {response in
            self.repositoryList = response
            self.repositoryCollectionView.reloadData()
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return repositoryList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = repositoryCollectionView.dequeueReusableCell(withReuseIdentifier: "myCell", for: indexPath) as! RepositoryCollectionViewCell
        let repository = repositoryList[indexPath.item]
        cell.nameLabel.text = repository.name
        cell.urlLabel.text = repository.url
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: repositoryCollectionView.frame.width, height: 50)
    }
    
}

class RepositoryCollectionViewCell : UICollectionViewCell{
    
    @IBOutlet weak var urlLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
}

extension String {
    
    func fromBase64() -> String? {
        guard let data = Data(base64Encoded: self) else {
            return nil
        }
        
        return String(data: data, encoding: .utf8)
    }
    
    func toBase64() -> String {
        return Data(self.utf8).base64EncodedString()
    }
}
