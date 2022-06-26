//
//  AccountNavigationController.swift
//  DeliveryApp
//
//  Created by Ofir Goren on 10/06/2022.
//

import UIKit

class AccountNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

      
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showBackgroundWave()
        
     
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    
    
        
    }
    
   
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("disspaer")
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
