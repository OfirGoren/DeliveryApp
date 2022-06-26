//
//  UiBtn.swift
//  DeliveryApp
//
//  Created by Ofir Goren on 06/06/2022.
//

import Foundation
import UIKit

class UiBtn:UIButton {
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        tintColor = UIColor(rgb: 0x11458E)
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        tintColor = UIColor(rgb: 0x11458E)
    }
    
   
    
    
}
