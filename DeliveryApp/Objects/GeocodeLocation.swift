//
//  GeocodeLocation.swift
//  DeliveryApp
//
//  Created by Ofir Goren on 09/06/2022.
//

import UIKit
import CoreLocation

class GeocodeLocation{
    
    
    var delegate: ((String) -> Void)?
    
    
    func getAddressFromLatLon(_ pdblLatitude: String,  _ pdblLongitude: String) {
        
        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
        let lat: Double = Double("\(pdblLatitude)")!
        //21.228124
        let lon: Double = Double("\(pdblLongitude)")!
        //72.833770
        let ceo: CLGeocoder = CLGeocoder()
        center.latitude = lat
        center.longitude = lon
        
        let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
        
        
        ceo.reverseGeocodeLocation(loc, completionHandler:
                                    {(placemarks, error) in
            if (error != nil)
            {
                print("reverse geodcode fail: \(error!.localizedDescription)")
            }
            let pm = placemarks! as [CLPlacemark]
            
            if pm.count > 0 {
                let pm = placemarks![0]
                var addressString : String = ""
                
                if pm.thoroughfare != nil {
                    addressString = addressString + pm.thoroughfare! + " "
                }
                if pm.subThoroughfare != nil {
                    addressString = addressString + pm.subThoroughfare! + ", "
                }
                if pm.locality != nil {
                    addressString = addressString + pm.locality!
                }
            
//                if pm.country != nil {
//                    addressString = addressString + pm.country! + ", "
//                }
//
//                if pm.postalCode != nil {
//                    addressString = addressString + pm.postalCode!
//                }
                
                print(addressString)
                if(addressString == "") {
                    addressString = "Not avalivale"
                }
                self.delegate?(addressString)
                
            }
        })
        
    }
    
}

