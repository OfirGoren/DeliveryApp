//
//  OrintationManager.swift
//  DeliveryApp
//
//  Created by Ofir Goren on 22/06/2022.
//

import UIKit
class OrientationManager {
    /// The currently allowed orientations of the application (default: .portrait)
    static var allowedOrientations: UIInterfaceOrientationMask = .portrait

    /**
     * Method to force the current orientation of the device.
     *
     * - Parameter orientation: The orientation to change to.
     *
     * - Warning: This method uses setValue(_, forKey:) which accesses values that may change in the future
     */
    static func forceOrientation(_ orientation: UIInterfaceOrientation) {
        let orientationRawValue = orientation.rawValue
        UIDevice.current.setValue(orientationRawValue, forKey: "orientation")
        UINavigationController.attemptRotationToDeviceOrientation()
    }
}
