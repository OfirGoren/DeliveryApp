//
//  Order.swift
//  DeliveryApp
//
//  Created by Ofir Goren on 17/06/2022.
//

import Foundation
import UIKit




 struct Order: Codable {
     
     var name:String = ""
     var phoneNum:String = ""
     var originAddress:String = ""
     var destinationAddress:String = ""
     var carOrMotorcycle:String = ""
     var DoucId:String = ""
     
     enum Vehicles:String {
        case car = "car"
        case motorcycle = "motorcycle"
     }
     
     init () {
         
     }
     
  
    
     
   
    
}


