//
//  File.swift
//  DeliveryApp
//
//  Created by Ofir Goren on 06/06/2022.
//

import UIKit

class UiTitle: UILabel{
    
    

    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.textColor = UIColor.white
        portraitLabelStyle()
     }
    
//    override func drawText(in rect: CGRect) {
//        super.drawText(in: rect)
//        self.textColor = UIColor.white
//
//        self.font = UIFont.boldSystemFont(ofSize: 30)
//
//    }
    
    func portraitLabelStyle()
       {
           self.font = UIFont.boldSystemFont(ofSize: 30)
           
       }
    
    func landScapeLabelStyle() {
        self.font = UIFont.boldSystemFont(ofSize: 20)
    }
    
    func labelBoldStyle(size: CGFloat) {
        self.font = UIFont.boldSystemFont(ofSize: size)
    }
    
    func labelBoldSize(size: CGFloat) {
        self.font = UIFont.boldSystemFont(ofSize: size)
    }
}
