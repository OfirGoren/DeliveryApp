//
//  StringExtenstion.swift
//  DeliveryApp
//
//  Created by Ofir Goren on 14/06/2022.
//

import Foundation



extension String {
    
     /*
     return true if email foramt is validate
     otherwise return false
     */
    func validateEmail() -> Bool {
        
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: self)
        
    }
    
    
}
