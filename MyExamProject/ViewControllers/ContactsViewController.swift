import UIKit
import Foundation
import ContactsUI

class ContactsViewController: ViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var contacts : [CNContact] = []
    @IBOutlet weak var contactsCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initMenuButton()
        let contactStore = CNContactStore()
        let keys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey]
        let request = CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])
        
        do {
            try contactStore.enumerateContacts(with: request) { (contact, stop) in
                self.contacts.append(contact)
            }
        } catch {
            print(error.localizedDescription)
        }
        contactsCollectionView.delegate = self
        contactsCollectionView.dataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return contacts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = contactsCollectionView.dequeueReusableCell(withReuseIdentifier: "myCell", for: indexPath) as! ContactCollectionViewCell
        let contact = contacts[indexPath.item]
        cell.title1.text = contact.givenName + " " + contact.familyName
        if(contact.phoneNumbers.count != 0) {
            cell.title2.text = contact.phoneNumbers[0].value.stringValue
        } else {
            cell.title2.text = "---"
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 60)
    }
    
}

class ContactCollectionViewCell : UICollectionViewCell{
    
    @IBOutlet weak var title1: UILabel!
    @IBOutlet weak var title2: UILabel!
    
}
