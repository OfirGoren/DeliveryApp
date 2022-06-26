//
//  Profile.swift
//  DeliveryApp
//
//  Created by Ofir Goren on 15/06/2022.
//

import Foundation



class Profile:Codable {
    
    var name:String = ""
    var email:String = ""
    var phoneNum:String = ""
    var photoUrl:String = ""
    var doucumentId:String = ""
 
    init() {
        
    }
    
    init(name:String , email:String ,doucumentId:String ) {
        self.name = name
        self.email = email
        self.doucumentId = doucumentId
    }
    
  
}
