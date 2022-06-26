//
//  CurrentLocation.swift
//  DeliveryApp
//
//  Created by Ofir Goren on 09/06/2022.
//

import UIKit
import CoreLocation
class CurrentLocation:NSObject, CLLocationManagerDelegate{
    
    let locationManager = CLLocationManager()
    var locationDelegate:((Double ,Double)-> Void)?
    var locationWithCourseDelegate:((Double ,Double ,Double?)-> Void)?
    var onlyOnceLocation = true
    
    override init() {
        super.init()
        initLocationSetting()
        
    }
    
    
    
    
    func initLocationSetting() {
        if CLLocationManager.locationServicesEnabled() {
            self.locationManager.requestWhenInUseAuthorization()
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
            
            
        }
    }
    
    func startGetLocation() {
        locationManager.startUpdatingLocation()
        
    }
    
    func stopGettingLocation() {
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
            //  stopGettingLocation()
        
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        
        // fixed the bug update location twice
        
        
            onlyOnceLocation = false
            locationDelegate?(Double(locValue.latitude) , Double(locValue.longitude))
            locationWithCourseDelegate?(Double(locValue.latitude) , Double(locValue.longitude) , locations.last?.course)
        
        
        
        
        
    }
    
    func onlyOnceLocation(isOneLocation:Bool) {
        onlyOnceLocation = isOneLocation
        
        
    }
    
    
}
