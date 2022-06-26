//
//  CustomSpinner.swift
//  DeliveryApp
//
//  Created by Ofir Goren on 14/06/2022.
//

import UIKit
import MaterialComponents.MaterialActivityIndicator
class CustomSpinner: UIView {

    
   
  private let activityIndicator = MDCActivityIndicator()
    
    let nibName = "CustomSpinner"
    
    @IBOutlet weak var parentView: UIView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
            //initSpinnerOnView()
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
        initSpinnerOnView()
    }
    
    private func initSpinnerOnView() {
        activityIndicator.stopAnimating()
        activityIndicator.sizeToFit()
        activityIndicator.cycleColors = [UIColor().myBlueColor()]
        activityIndicator.progress = 1
        parentView.addSubview(activityIndicator)
        addCostraints()
       
        
        
    }
    private func addCostraints() {
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        let horConstraint = NSLayoutConstraint(item: activityIndicator, attribute: .centerX, relatedBy: .equal, toItem: parentView, attribute: .centerX ,multiplier: 1.0, constant: 0.0)
        let verConstraint = NSLayoutConstraint(item: activityIndicator, attribute: .centerY, relatedBy: .equal, toItem: parentView, attribute: .centerY ,multiplier: 1.0, constant: 0.0)
        
        parentView.addConstraints([horConstraint, verConstraint])
    }
    
 
    
    func commonInit() {
        guard let view = loadViewFromNib() else { return }
        view.frame = self.bounds
        self.addSubview(view)
        
    }
    
   
    func loadViewFromNib() -> UIView? {
           let nib = UINib(nibName: nibName, bundle: nil)
           return nib.instantiate(withOwner: self, options: nil).first as? UIView
       }
    
    
    
    func startSpinner() {
        activityIndicator.startAnimating()
    }

    func stopSpinner() {
        activityIndicator.stopAnimating()
    }
}
