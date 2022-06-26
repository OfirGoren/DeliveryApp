
//  Created by Ofir Goren on 22/06/2022.


import UIKit
import Foundation

class NavigationPickerManager {
    let googleNavigation:String = "Google"
    let wazeNavigation:String = "Waze"
    let cancel = "Cancel"
    let title = "Navigation"
    var origin:String?
    var alert: UIAlertController
    var viewController:UIViewController?
    var resultsCallBack:((ResultsNavigation)->Void)?
    
    public enum ResultsNavigation {
        case CANCEL
        case WAZE
        case GOOGLE
        
    }
    
    init() {
        self.alert = UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)
        initAlert()
    }
    
    
    private func initAlert() {
        let googleNavigationAction = UIAlertAction(title: googleNavigation, style: .default){
            UIAlertAction in
            self.openGoogleNavigation()
        }
        let wazeAction = UIAlertAction(title: wazeNavigation, style: .default){
            UIAlertAction in
            self.openWazeNavigation()
        }
        let cancelAction = UIAlertAction(title: cancel, style: .cancel){
            UIAlertAction in
            self.resultsCallBack?(ResultsNavigation.CANCEL)
        }
        
        // Add the actions
        alert.addAction(googleNavigationAction)
        alert.addAction(wazeAction)
        alert.addAction(cancelAction)
        
        
    }
    
    
    func navigationPicker(viewController:UIViewController,origin:String? , _ callBack:((_:ResultsNavigation)->Void)?) {
        self.viewController = viewController
        self.origin = origin
        self.resultsCallBack = callBack
        self.alert.popoverPresentationController?.sourceView = self.viewController!.view
        
        viewController.present(alert, animated: true, completion: nil)
    }
    
    
    private func openGoogleNavigation() {
        alert.dismiss(animated: true, completion: nil)
        //check Google Maps installed on User's phone.
        if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {
            if let mOrigin = self.origin {
                //It will open native google maps app.
                let temp = "?saddr=&daddr=\(mOrigin)&directionsmode=driving&zoom=17"
                let comGoogleMaps = "comgooglemaps://" + temp.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
                UIApplication.shared.open(URL(string: comGoogleMaps)!)
                self.resultsCallBack?(ResultsNavigation.GOOGLE)
            }
        }  else {
            // Launch AppStore to install Google maps app
            UIApplication.shared.open(URL(string:"http://itunes.apple.com/us/app/id585027354")!)
            
        }
        
    }
    
    
    private func openWazeNavigation() {
        alert.dismiss(animated: true, completion: nil)
        // check Waze installed on User's phone.
        if (UIApplication.shared.canOpenURL(URL(string:"https://waze.com/")!)) {  //First check Google Mpas installed on User's phone or not.
            if let mOrigin = self.origin {
                //open waze app.
                let temp = "ul?q=\(mOrigin)&navigate=yes"
                let openWazeAddress = "https://waze.com/" + temp.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
                UIApplication.shared.open(URL(string: openWazeAddress)!)
                self.resultsCallBack?(ResultsNavigation.WAZE)
                
            }
            // When waze isn't installed in davice
        } else {
            // Launch AppStore to install Waze app
            UIApplication.shared.open(URL(string:"http://itunes.apple.com/us/app/id323229106")!)
        }
        
    }
    
    
}
