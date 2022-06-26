//
//  AllOrdersViewController.swift
//  DeliveryApp
//
//  Created by Ofir Goren on 20/06/2022.
//

import UIKit


protocol AllOrdersViewControllerDelegate {
    func OrderDetails(order:Order)
    
    
}

class AllOrdersViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var progressBarView: CustomSpinner!
    private let fireStoreHandler = FireStoreHandler()
    private var allOrders:[Order] = []
    private let refreshControl = UIRefreshControl()
    private var currentCell: TableViewCell?
    @IBOutlet weak var titleLabel: UiTitle!
    var allOrdersControllerDelegate:AllOrdersViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initCell()
        self.initDelegate()
        self.initLongPressGestureRecognizer()
        self.initRefreshControll()
         self.getAllOrderFromDB()
        
    }
    
    

    
    private func initCell() {
        let textFieldCell = UINib(nibName: "TableViewCell",bundle: nil)
        self.tableView.register(textFieldCell,forCellReuseIdentifier: "TableViewCell")
        
    }
    
    private func initRefreshControll() {
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh", attributes: [NSAttributedString.Key.foregroundColor: UIColor().myBlueColor()])
        self.refreshControl.tintColor = UIColor().myBlueColor()
        self.refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        self.tableView.addSubview(refreshControl)
        
    }
    // when user refresh tableView
    @objc func refresh(_ sender: AnyObject) {
        self.getAllOrderFromDB()
        self.refreshControl.endRefreshing()
        
    }
    
    private func initDelegate() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.rowHeight = 160
        self.tableView.allowsSelection = true
    }
 
    
    private func getAllOrderFromDB() {
        fireStoreHandler.getAllOrders() {[weak self] orders in
            self?.allOrders.removeAll()
            self?.allOrders = orders
            self?.tableView.reloadData()
            self?.activateProgressBar(isHidden: true , play: false)
            
        }
    }
    
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        if UIDevice.current.orientation.isLandscape {
            print("sdfsfd")
            titleLabel.landScapeLabelStyle()
        }
        if UIDevice.current.orientation.isFlat {
        } else if UIDevice.current.orientation.isPortrait  {
            titleLabel.portraitLabelStyle()
        }
    }

    
    private func initLongPressGestureRecognizer() {
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        longPress.minimumPressDuration = 0.05
        self.tableView.addGestureRecognizer(longPress)
        
        
    }
    
    private func  removeOrderAccordingIndex(_ index:Int) ->Order {
        let order = allOrders[index]
        self.allOrders.remove(at: index)
        return order
    }
    
    private func activateProgressBar(isHidden:Bool , play:Bool) {
        self.progressBarView.isHidden = isHidden
        if(play) {
            self.progressBarView.startSpinner()
        }else {
            self.progressBarView.stopSpinner()
        }
    }
    
    private func handleNavigationDestination(indexPath:IndexPath , currentCell: TableViewCell?) {
        NavigationPickerManager().navigationPicker(viewController: self, origin: currentCell?.originLabel.text) { [weak self]  result in
            if let strongSelf = self {
                // when user take the shippnig
                if(result != NavigationPickerManager.ResultsNavigation.CANCEL) {
                    let order = strongSelf.removeOrderAccordingIndex(indexPath.row)
                    strongSelf.removeOrderFromAllOrdersDB(order)
                    let array:[IndexPath] = Array(arrayLiteral: indexPath)
                    strongSelf.tableView.deleteRows(at: array, with: UITableView.RowAnimation.automatic)
                    print("sdfdsf")
                    
                    if let tabBar = self?.tabBarController as? TabBarViewController {
                        tabBar.allOrdersControllerDelegate?.OrderDetails(order: order)
                    }
                    
                    
                }
                
                
            }
            
            
        }
    }
    private func removeOrderFromAllOrdersDB(_ order:Order) {
        self.fireStoreHandler.removeOrderFromAllOrders(order)
        
    }
    
}




extension AllOrdersViewController: UITableViewDelegate {
    
    
}
extension AllOrdersViewController:UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  allOrders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        cell.nameLabel.text = allOrders[indexPath.row].name
        cell.phoneNumLabel.text = allOrders[indexPath.row].phoneNum
        cell.originLabel.text = allOrders[indexPath.row].originAddress
        cell.destinationLabel.text = allOrders[indexPath.row].destinationAddress
        cell.addVehicleImage(PicName: allOrders[indexPath.row].carOrMotorcycle)
        return cell
        
    }
    
    
    
    @objc func handleTap(_ sender: UILongPressGestureRecognizer? = nil) {
        
        let touchPoint = sender?.location(in: tableView)
        var currentCell: TableViewCell?
        var mIndexPath: IndexPath?
        
        if let indexPath = tableView.indexPathForRow(at: touchPoint!) {
            mIndexPath = indexPath
            currentCell = tableView.cellForRow(at: indexPath) as! TableViewCell?
        }
        // when user pressing on cell in tableview
        if(sender?.state  == UIGestureRecognizer.State.began) {
            // remove shadowOffset to create animation press cell
            self.currentCell = currentCell
            currentCell?.cardViewCell.deleteShadowOffsetCardEffect()
        }
        // when user released pressing on cell
        else if(sender?.state  == UIGestureRecognizer.State.ended) {
            // return card effect on cell
            self.currentCell?.cardViewCell.cardEffect()
            if let indexPath = mIndexPath {
                if(self.currentCell == currentCell) {
                    self.handleNavigationDestination(indexPath: indexPath , currentCell: currentCell)
                }
            }
            
        }
        
        
    }
    
}
