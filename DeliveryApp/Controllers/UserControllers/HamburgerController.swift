

import UIKit


protocol HamburgerViewControllerDelegate {
    func hideHamburger()
    func myOrderPressed()
    func openCourierAccount()
    
}


class HamburgerController: UIViewController {

    var delegate:HamburgerViewControllerDelegate? = nil
    
    @IBOutlet weak var userPicture: UIImageView!
    @IBOutlet weak var userDetailsView: UIView!
    @IBOutlet weak var userNameLabel: UILabel!
    private let fireBaseAuthHandler = FireBaseAuthHandler()
    private let firesBaseStorageHandler = fireBaseStorageHandler()
    private let firesStoreHandler = FireStoreHandler()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initInterectEnabled()
        getCurrentUserDetails()
        setUi()
        
    
    }
 
    
    private func initInterectEnabled() {
        userPicture.isUserInteractionEnabled = true
    }
    private func setUi() {
        self.userDetailsView.CircleView()
        self.userPicture.setRounded()
    }
    
    
    @IBAction func logOutPressed(_ sender: Any) {
        fireBaseAuthHandler.signOut()
        self.navigationController?.dismiss(animated: true) {
        
        }
            
    }
    @IBAction func menuPressed(_ sender: Any) {
        delegate?.hideHamburger()
    }
    
    @IBAction func MyOrderPressed(_ sender: Any) {
        delegate?.myOrderPressed()
    }
    
    @IBAction func CourierAccountPressed(_ sender: Any) {
        delegate?.openCourierAccount()
    }
    
    
    private func getCurrentUserDetails() {
        firesStoreHandler.getUserProfile() { [weak self] profile in
            print(profile)
            self?.userPicture.loadFrom(URLAddress: profile.photoUrl)
            self?.userNameLabel.text = profile.name
            
        }
        
    }
    
    
    @IBAction func recognizerPhotoViewPressed(_ sender: UITapGestureRecognizer) {
        
        ImagePickerManager().pickImage(self){ [weak self] imageUrl , image in
            self?.userPicture.image = image
            self?.uploadImageToStorage(imageUrl)
            
            
    }
    
      
        
}
    

    private func uploadImageToStorage(_ imageUrl:URL) {
        firesBaseStorageHandler.uploadImage(url: imageUrl) { storageUrlPhoto in
            print(storageUrlPhoto)
            self.firesStoreHandler.updateUrlPhotoDB(url: storageUrlPhoto)
            
            
        }
        
        
    }
    
}
    

    

    

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
   
    

