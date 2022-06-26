//
//  MapViewController.swift
//  DeliveryApp
//
//  Created by Ofir Goren on 20/06/2022.
//

import UIKit
import GoogleMaps
import CoreLocation
import SwiftUI


protocol MapViewControllerDelegate {
    func logOut()
    
}



class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var statePackageBtn: UIButton!
    @IBOutlet weak var orderDetailView: UIView!
    @IBOutlet weak var orderNameLabel: UILabel!
    
    
    
    @IBOutlet weak var orderPhoneLabel: UILabel!
    
    
    
    @IBOutlet weak var titleLabel: UiTitle!
    private let currentLocation = CurrentLocation()
    private var marker:GMSMarker?
    private var wait = true
    private var order: Order?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initValuesPackageBtn()
        self.initOrderDetailView()
        self.initMarker()
        self.initDelegate()
        self.currentLocation.startGetLocation()
        
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let tabBar = self.tabBarController as? TabBarViewController {
            tabBar.allOrdersControllerDelegate = self
            
        }
    }
    
    
    
    private func initValuesPackageBtn() {
        self.statePackageBtn.titleLabel?.font = .systemFont(ofSize: 15)
        self.statePackageBtn.roundedView(size: 55)
        self.statePackageBtn.titleLabel?.textAlignment = .center
        self.statePackageBtn.isHidden = true
    }
    
    
    
    private func initOrderDetailView() {
        self.orderDetailView.isHidden = true
        self.orderDetailView.roundedView(size: 10)
    }
    
    private func initDelegate() {
        self.mapView?.delegate = self
        self.currentLocation.locationWithCourseDelegate = self.locationWithCours(_:_:_:)
    }
    
    @IBAction func arrivedPressed(_ sender: Any) {
        // when user press the btn (picked the package)
        if(self.statePackageBtn.titleLabel?.text == StringUtils.pickedThePakage) {
            // change title to "the packge was delivered"
            self.statePackageBtn.setTitle(StringUtils.deliverd, for: .normal)
            // user navigate to delived the package
            NavigationPickerManager().navigationPicker(viewController: self, origin: order?.destinationAddress , nil)
            // when user press when he delivered the package
        }else if(self.statePackageBtn.titleLabel?.text == StringUtils.deliverd) {
            
            self.statePackageBtn.isHidden = true
            self.orderDetailView.isHidden = true
            
        }
    }
    
    
    
    private func initMarker() {
        marker = GMSMarker()
        let navigator = UIImage(named: "navigator")!
        let markerView = UIImageView(image: navigator)
        // resize the icon
        markerView.frame = CGRect(x: 0 , y: 0 , width: 50 , height: 50)
        marker?.iconView = markerView
        
    }
    
    
    
    private func locationWithCours(_ lat:Double , _ long:Double,_ angle:Double?) {
        let camera = GMSCameraPosition(target: CLLocationCoordinate2D(latitude: lat, longitude: long), zoom: 17)
        mapView?.animate(to: camera)
        
        self.marker?.map = self.mapView
        let point = CLLocationCoordinate2D(latitude: lat,longitude: long)
        
        updateMarkerWith(position: point, angle: angle!)
        
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        if UIDevice.current.orientation.isLandscape {
            print("sdfsfd")
            titleLabel.landScapeLabelStyle()
        }
        if UIDevice.current.orientation.isFlat {
        } else if UIDevice.current.orientation.isPortrait  {
            titleLabel.portraitLabelStyle()
        }
    }
    func updateMarkerWith(position: CLLocationCoordinate2D, angle: Double) {
        marker?.position = position // CLLocationCoordinate2D coordinate
        
        guard angle >= 0 && angle < 360 else {
            return
        }
        if(wait) {
            wait = false
            let angleInRadians: CGFloat = CGFloat(angle) * .pi / CGFloat(180) //Form degrees to radians transformation
            UIView.animate(withDuration: 1 , animations:  {
                self.marker?.iconView?.transform = CGAffineTransform.identity.rotated(by: angleInRadians)
            }) { (status) in
                self.wait = true
            }
        }
        
    }
    
}









extension MapViewController:GMSMapViewDelegate {
    
}

extension MapViewController:AllOrdersViewControllerDelegate {
    func OrderDetails(order: Order) {
        print("dsgdssg")
        self.statePackageBtn.isHidden = false
        self.statePackageBtn.setTitle(StringUtils.pickedThePakage, for: .normal)
        self.order = order
        
        self.orderDetailView.isHidden = false
        self.orderNameLabel.text = order.name
        self.orderPhoneLabel.text = order.phoneNum
    }
    
    
    
    
}
