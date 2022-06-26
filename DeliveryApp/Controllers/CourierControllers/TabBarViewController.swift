//
//  TabBarViewController.swift
//  DeliveryApp
//
//  Created by Ofir Goren on 23/06/2022.
//

import UIKit

class TabBarViewController: UITabBarController {

    var allOrdersControllerDelegate:AllOrdersViewControllerDelegate?
    
    var mapViewControllerDelegate:MapViewControllerDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
    
        
    }

  
    deinit {
        
        allOrdersControllerDelegate = nil
        mapViewControllerDelegate = nil
    }

}
