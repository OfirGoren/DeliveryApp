//
//  cardEffectCell.swift
//  DeliveryApp
//
//  Created by Ofir Goren on 17/06/2022.
//

import Foundation
import UIKit


class CardEffectCell:UIView {
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        cardEffect()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        cardEffect()
    }
    
    func cardEffect()  {
        self.layer.shadowColor = UIColor().myBlueColor().cgColor
        self.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        self.layer.shadowOpacity = 2.0
        self.layer.masksToBounds = false
        self.layer.cornerRadius = 10.0
        
        
        
    }
    func deleteShadowOffsetCardEffect()  {
        self.layer.shadowColor = UIColor().myBlueColor().cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        self.layer.shadowOpacity = 2.0
        self.layer.masksToBounds = false
        self.layer.cornerRadius = 10.0
        
        
        
    }
    
    
    
    
    
    
}
