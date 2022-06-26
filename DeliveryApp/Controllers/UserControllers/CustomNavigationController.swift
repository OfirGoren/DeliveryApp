//
//  WelcomeNavigationController.swift
//  DeliveryApp
//
//  Created by Ofir Goren on 06/06/2022.
//

import UIKit



class CustomNavigationController: UINavigationController {

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
   
    
    override func viewDidAppear(_ animated: Bool) {
        showBackgroundWave()
        
    }
    

    
    
    private func showBackgroundWave() {
        print("DGfgfd")
        if #available(iOS 15.0, *) {
                let appearance = UINavigationBarAppearance()
                appearance.configureWithTransparentBackground()
                appearance.backgroundImage = UIImage(named: "Wave")
                navigationBar.standardAppearance = appearance
                navigationBar.scrollEdgeAppearance = navigationBar.standardAppearance
            }else{
                self.navigationBar.setBackgroundImage(UIImage(named: "Wave"), for: .default)
            }
    }
    
}


