//
//  UiView.swift
//  DeliveryApp
//
//  Created by Ofir Goren on 07/06/2022.
//

import UIKit


extension UIView{

func CircleView() {
    
    self.layer.cornerRadius = 40
    self.layer.maskedCorners = [.layerMaxXMaxYCorner]
    self.clipsToBounds = true

    }
    
    func shake() {
          let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
          animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
          animation.duration = 0.6
          animation.values = [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0 ]
          layer.add(animation, forKey: "shake")
      }
    
    func roundedView(size:CGFloat) {
        self.layer.cornerRadius = size
        self.clipsToBounds = true
        
    }
    
    func rotate(angle:CGFloat) {
           let rotation : CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
           rotation.toValue = NSNumber(value: angle)
           rotation.duration = 1
           rotation.isCumulative = true
           rotation.repeatCount = Float.greatestFiniteMagnitude
           self.layer.add(rotation, forKey: "rotationAnimation")
       }
    
    
    func fadeIn(duration: TimeInterval = 0.5,
                 delay: TimeInterval = 0.0,
                 completion: @escaping ((Bool) -> Void) = {(finished: Bool) -> Void in }) {
       UIView.animate(withDuration: duration,
                      delay: delay,
                      options: UIView.AnimationOptions.curveEaseIn,
                      animations: {
         self.alpha = 1.0
       }, completion: completion)
     }

     func fadeOut(duration: TimeInterval = 0.5,
                  delay: TimeInterval = 0.0,
                  completion: @escaping (Bool) -> Void = {(finished: Bool) -> Void in }) {
       UIView.animate(withDuration: duration,
                      delay: delay,
                      options: UIView.AnimationOptions.allowUserInteraction,
                      animations: {
         self.alpha = 0.0
       }, completion: completion)
     }
    
}
