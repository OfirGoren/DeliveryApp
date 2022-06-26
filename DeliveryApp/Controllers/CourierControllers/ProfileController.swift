//
//  ProfileController.swift
//  DeliveryApp
//
//  Created by Ofir Goren on 23/06/2022.
//

import UIKit

class ProfileController: UIViewController {
    
    
    @IBOutlet weak var titleLabel: UiTitle!
    @IBOutlet weak var loadDataSpinnerView: UIView!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    private let firesBaseStorageHandler = fireBaseStorageHandler()
    private let firesStoreHandler = FireStoreHandler()
    private let fireBaseAuthHandler = FireBaseAuthHandler()
    @IBOutlet weak var spinnerView: CustomSpinner!
    override func viewDidLoad() {
        super.viewDidLoad()
        spinnerView.startSpinner()
        getCurrentUserDetails()
        setUi()
        userImageView.isUserInteractionEnabled = true
        // Do any additional setup after loading the view.
    }
    
    
    private func getCurrentUserDetails() {
        firesStoreHandler.getUserProfile() { [weak self] profile in
            if let strongSelf = self {
                strongSelf.loadDataSpinnerView.fadeOut()
                strongSelf.userImageView.loadFrom(URLAddress: profile.photoUrl)
                strongSelf.nameLabel.text = profile.name
                strongSelf.emailLabel.text = profile.email
                
                
            }
        }
    }
    
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        if UIDevice.current.orientation.isLandscape {
            titleLabel.landScapeLabelStyle()
        }
        if UIDevice.current.orientation.isFlat {
        } else if UIDevice.current.orientation.isPortrait  {
            titleLabel.portraitLabelStyle()
        }
    }
    
    private func setUi() {
        
        self.userImageView.setRounded()
    }
    
    
    @IBAction func uploadImagePressed(_ sender: Any) {
        
        ImagePickerManager().pickImage(self){ [weak self] imageUrl , image in
            self?.userImageView.image = image
            self?.uploadImageToStorage(imageUrl)
            
            
        }
        
    }
    @IBAction func LogOutpressed(_ sender: Any) {
        if let controller = self.tabBarController as? TabBarViewController {
            fireBaseAuthHandler.signOut()
            self.tabBarController?.dismiss(animated: false)
            controller.mapViewControllerDelegate?.logOut()
            
        }
        
        
    }
    
    
    @IBAction func returnPressed(_ sender: Any) {
        self.tabBarController?.dismiss(animated: true)
        
    }
    private func uploadImageToStorage(_ imageUrl:URL) {
        firesBaseStorageHandler.uploadImage(url: imageUrl) { storageUrlPhoto in
            print(storageUrlPhoto)
            self.firesStoreHandler.updateUrlPhotoDB(url: storageUrlPhoto)
            
            
        }
        
        
    }
}

