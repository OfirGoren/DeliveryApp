//
//  MyOrderController.swift
//  DeliveryApp
//
//  Created by Ofir Goren on 16/06/2022.
//

import UIKit
import MaterialComponents.MaterialActivityIndicator
class MyOrderController: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    private var myOrders:[Order] = []
    private let fireStoreHandler = FireStoreHandler()
    
    
    @IBOutlet weak var customSpinnerView: CustomSpinner!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerTableViewCells()
        getMyOrderFromDB()
        customSpinnerView.startSpinner()
        

    }
    
    private func registerTableViewCells() {
        let textFieldCell = UINib(nibName: "TableViewCell",
                                  bundle: nil)
        self.tableView.register(textFieldCell,
                                forCellReuseIdentifier: "TableViewCell")
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.rowHeight = 160
        
    }
    
    
    private func  getMyOrderFromDB() {
        fireStoreHandler.getMyOrders() { [weak self] orders in
            self?.myOrders += orders
            self?.tableView.reloadData()
            self?.customSpinnerView.stopSpinner()
        }
        
        
    }
    
}

extension MyOrderController : UITableViewDelegate {
    
    
}

extension MyOrderController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  myOrders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        
        let index = indexPath.row
        cell.addNameLabel(name: myOrders[index].name)
        cell.addPhoneNumber(phoneNum: myOrders[index].phoneNum)
        cell.addOriginAddress(origin: myOrders[index].originAddress)
        cell.addDestinationAddress(destination: myOrders[index].destinationAddress)
        cell.addVehicleImage(PicName: myOrders[index].carOrMotorcycle)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        
    }
    
}
