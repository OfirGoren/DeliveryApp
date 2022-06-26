//
//  UiImageView.swift
//  DeliveryApp
//
//  Created by Ofir Goren on 07/06/2022.
//


import UIKit


extension UIImageView {
    
    
    func setRounded() {
        self.layer.masksToBounds = true
        self.layer.cornerRadius = self.frame.size.width / 2
        self.clipsToBounds = true
      }
    
    func loadFrom(URLAddress: String) {
        guard let url = URL(string: URLAddress) else {
            return
        }
        
        DispatchQueue.main.async { [weak self] in
            if let imageData = try? Data(contentsOf: url) {
                if let loadedImage = UIImage(data: imageData) {
                        self?.image = loadedImage
                }
            }
        }
    }
}

