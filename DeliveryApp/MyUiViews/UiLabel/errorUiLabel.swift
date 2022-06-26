//
//  errorUiLabel.swift
//  DeliveryApp
//
//  Created by Ofir Goren on 13/06/2022.
//

import Foundation
import UIKit


class errorUILabel:UILabel {
    
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initLabel()
        
    }
    
    
    private func initLabel() {
        self.textColor = UIColor.red
        self.font = UIFont(name: "Arial", size: 15)
        
        
        
    }
    
}
