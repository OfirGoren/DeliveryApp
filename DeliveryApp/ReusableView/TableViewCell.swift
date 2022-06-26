//
//  TableViewCell.swift
//  DeliveryApp
//
//  Created by Ofir Goren on 17/06/2022.
//

import UIKit

class TableViewCell: UITableViewCell {

 
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneNumLabel: UILabel!
    @IBOutlet weak var originLabel: UILabel!
    @IBOutlet weak var destinationLabel: UILabel!
    
    @IBOutlet weak var vehicleImageView: UIImageView!
    @IBOutlet weak var cardViewCell: CardEffectCell!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
            
        // Configure the view for the selected state
    }
    
    func addNameLabel(name:String) {
        nameLabel.text = name
    }
    
    func addPhoneNumber(phoneNum:String) {
        phoneNumLabel.text = phoneNum
    }
    func addOriginAddress(origin:String) {
        originLabel.text = origin
        
    }
    func addDestinationAddress(destination:String) {
        destinationLabel.text = destination
    }
    func addVehicleImage(PicName:String) {
        vehicleImageView.image = UIImage(named:PicName)
    }
    
}
