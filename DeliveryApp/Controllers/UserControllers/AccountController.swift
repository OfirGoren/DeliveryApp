//
//  AccountController.swift
//  DeliveryApp
//
//  Created by Ofir Goren on 07/06/2022.
//

import UIKit
import GoogleMaps
import CoreLocation
class AccountController: UIViewController {
    
    @IBOutlet weak var leadingConstraintHamburgerView: NSLayoutConstraint!
    
    
    @IBOutlet weak var menuBtn: UIButton!
    @IBOutlet weak var hamburgerBackView: UIView!
    @IBOutlet weak var MotorcycleBtn: UIButton!
    @IBOutlet weak var carBtn: UIButton!
    @IBOutlet weak var upToFiveKgLabel: UILabel!
    @IBOutlet weak var upToTenKgLebal: UILabel!
    @IBOutlet weak var markerImage: UIImageView!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var titleLabel: UiTitle!
    @IBOutlet weak var centeringView: UIView!
    
    @IBOutlet weak var centerLocationBtn: UIButton!
    private let currentLocation = CurrentLocation()
    private var deliveryKindChoosen:String?
    private let initLocationEnabeleOnce = true
    private let geocodeLocation = GeocodeLocation()
    private var initMapOnce = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.centeringView.roundedView(size:10)
        self.hamburgerBackView.isHidden = true
        self.initIconsColor()
        self.initUiItems()
        self.initDelegates()
        self.currentLocation.startGetLocation()
        
        
        
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //  rotate and lock
        
        AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)
        
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        AppUtility.lockOrientation(.all)
    }
    
    private func initDelegates() {
        self.mapView?.delegate = self
        geocodeLocation.delegate = self.getAddressDelegate(_:)
        currentLocation.locationDelegate = getCurrentLocation(_:_:)
    }
    
    private func initToGetCurrentLocation() {
        currentLocation.startGetLocation()
    }
    
    
    private func initUiItems() {
        deliveryKindChoosen = StringUtils.motorcycle
        titleLabel.labelBoldSize(size: 20)
    }
    
    
    
    // get current location callBack
    private func showCurrentLocationOnMap(_ lat:Double , _ long:Double) {
        
        currentLocation.stopGettingLocation()
        let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: long, zoom: 18)
        self.mapView?.camera = camera
        self.mapView?.animate(to: camera)
        
        
        
    }
    
    
    
    private func updateAddressAccoringCoordinates(_ lat:Double , _ long:Double) {
        geocodeLocation.getAddressFromLatLon(String(lat), String(long))
        
        
    }
    
    
    private func getAddressDelegate(_ address:String) {
        addressLabel.text = address
        
        
        
    }
    
    private func getCurrentLocation(_ lat:Double , _ long:Double) {
        showCurrentLocationOnMap(lat ,long )
        
        
    }
    
    private func  initIconsColor() {
        MotorcycleBtn.tintColor = UIColor().myBlueColor()
        upToFiveKgLabel.textColor = UIColor().myBlueColor()
    }
    
    
    @IBAction func carBtnPressed(_ sender: UIButton) {
        
        changeCarIconAndLebalToBlueColor()
        changeMotorcycleIconAndLabelToGrayColor()
        deliveryKindChoosen = StringUtils.car
    }
    
    
    @IBAction func motorcycleBtnPressed(_ sender: UIButton) {
        changeMotorcycleIconAndLabelToBlueColor()
        changeCarIconAndLebalToGrayColor()
        deliveryKindChoosen = StringUtils.motorcycle
        
    }
    
    @IBAction func centerLocationBtn(_ sender: UIButton) {
        currentLocation.onlyOnceLocation(isOneLocation: true)
        currentLocation.startGetLocation()
        
        
    }
    
    private func changeCarIconAndLebalToGrayColor() {
        carBtn.tintColor = UIColor().myGrayColor()
        upToTenKgLebal.textColor = UIColor().myGrayColor()
        
        
    }
    private func changeCarIconAndLebalToBlueColor() {
        carBtn.tintColor = UIColor().myBlueColor()
        upToTenKgLebal.textColor = UIColor().myBlueColor()
        
        
    }
    private func changeMotorcycleIconAndLabelToGrayColor() {
        MotorcycleBtn.tintColor = UIColor().myGrayColor()
        upToFiveKgLabel.textColor = UIColor().myGrayColor()
        
        
    }
    private func changeMotorcycleIconAndLabelToBlueColor() {
        MotorcycleBtn.tintColor = UIColor().myBlueColor()
        upToFiveKgLabel.textColor = UIColor().myBlueColor()
        
        
    }
    
    
    @IBAction func menuPressed(_ sender: Any) {
        self.hamburgerBackView.isHidden = false
        self.menuBtn.isHidden = true
        self.showHamburgerView()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == StringUtils.hamburgerSegue) {
            if let controller = segue.destination as? HamburgerController {
                controller.delegate = self
            }
        }
        else if (segue.identifier == StringUtils.orderDeliveryIdentifier) {
            if let controller = segue.destination as? OrderController {
                controller.deliveryKindChoosen = self.deliveryKindChoosen
                controller.originAddress = self.addressLabel.text
                
            }
            
        }else if(segue.identifier == StringUtils.CurierAccountIdentifier) {
            if let controller = segue.destination as? TabBarViewController {
                controller.mapViewControllerDelegate = self
            }
            
        }
        
    }
    
    
    @IBAction func tappedHamburgerBackView(_ sender: Any) {
        self.hideHamburger()
    }
    

    private func showHamburgerView() {
        UIView.animate(withDuration: 0.3,animations: {
            self.leadingConstraintHamburgerView.constant = 20
            self.view.layoutIfNeeded()
        }) { (status) in
            UIView.animate(withDuration: 0.3, animations: {
                self.leadingConstraintHamburgerView.constant = 0
                self.view.layoutIfNeeded()
            })
            
        }
        
        
        
    }
    
    
}



/*
 --------------------------- Extentions -------------------------------
 */
extension AccountController:HamburgerViewControllerDelegate {
    
    func openCourierAccount() {
        
        performSegue(withIdentifier:"CurierAccountIdentifier", sender: self)
        
        
    }
    
    
    func myOrderPressed() {
        performSegue(withIdentifier:"MyOrderIdentifier", sender: self)
    }
    
    func hideHamburger() {
        
        UIView.animate(withDuration: 0.3,animations: {
            self.leadingConstraintHamburgerView.constant = 20
            self.view.layoutIfNeeded()
        }) { (status) in
            UIView.animate(withDuration: 0.3, animations: {
                self.leadingConstraintHamburgerView.constant = -280
                self.view.layoutIfNeeded()
            }) {(status) in
                self.hamburgerBackView.isHidden = true
                self.menuBtn.isHidden = false
                
            }
            
        }
        
    }
}
extension AccountController:GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        self.addressLabel.text = "Search..."
        
    }
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        let lat = Double(mapView.camera.target.latitude)
        let long = Double(mapView.camera.target.longitude)
        self.updateAddressAccoringCoordinates(lat,long)
        
    }
    
}
extension AccountController:MapViewControllerDelegate {
    func logOut() {
        self.navigationController?.dismiss(animated: false)
    }
    
    
    
    
}
