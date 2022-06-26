//
//  OrderController.swift
//  DeliveryApp
//
//  Created by Ofir Goren on 10/06/2022.
//

import UIKit

class OrderController: UIViewController {
    
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var originTextField: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var titleLabel: UiTitle!
    @IBOutlet weak var destinationTextField: UITextField!
    @IBOutlet weak var motorcycleBtn: UIButton!
    @IBOutlet weak var carBtn: UIButton!
    @IBOutlet weak var upToTenKgLebal: UILabel!
    @IBOutlet weak var upToFiveKgLabel: UILabel!
    
    
    @IBOutlet weak var errorNameLabel: errorUILabel!
    @IBOutlet weak var errorPhoneLabel: errorUILabel!
    @IBOutlet weak var errorOriginLabel: errorUILabel!
    @IBOutlet weak var errorDestinationLabel: errorUILabel!
    
    var deliveryKindChoosen:String?
    var originAddress:String?
    private var carPressed:Bool = false
    private let fireStoreHandler = FireStoreHandler()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.setNeedsLayout()
        // Do any additional setup after loading the view.
        initMsgsErrorHidden()
        initDelegate()
        initObserverToKeyBoard()
        initColorIconAndLabel()
        initOriginAddress()
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        if UIDevice.current.orientation.isLandscape {
            titleLabel.landScapeLabelStyle()
        }
        if UIDevice.current.orientation.isFlat {
        } else if UIDevice.current.orientation.isPortrait  {
            titleLabel.portraitLabelStyle()
        }
    }
    
    private func initMsgsErrorHidden() {
        errorNameLabel.isHidden = true
        errorPhoneLabel.isHidden = true
        errorOriginLabel.isHidden = true
        errorDestinationLabel.isHidden = true
    }
    
    private func initDelegate() {
        nameTextField.delegate = self
        phoneTextField.delegate = self
        originTextField.delegate = self
        destinationTextField.delegate = self
        
    }
    
    
    private func getAllTextFieldsText() -> (name:String , phoneNum:String , origin:String , destination:String) {

        let name = nameTextField.text ?? ""
        let phoneNum = phoneTextField.text ?? ""
        let originAddress = originTextField.text ?? ""
        let desinationAddress = destinationTextField.text ?? ""
        
        
        return(name , phoneNum , originAddress , desinationAddress)


    }
    
    
    // check all the textField and if there is need to
    // show errors msg we display
    private func  handleErrorMsg(textFieldsTexts:(name:String , phoneNum:String , origin:String , destination:String)) {
        
        
        // backgorund Thread
        let isRequireNameErrorMsg = ErrorMsgHandler.isNameNeedErrorMsg(msg: textFieldsTexts.name)
        let isRequirePhoneErrorMsg = ErrorMsgHandler.isPhoneNumNeedErrorMsg(msg: textFieldsTexts.phoneNum)
        let isRequireOriginErrorMsg = ErrorMsgHandler.isOriginNeedErrorMsg(msg: textFieldsTexts.origin)
        let isRequireDestiErrorMsg = ErrorMsgHandler.isDestinationNeedErrorMsg(msg: textFieldsTexts.destination)
            
            
            DispatchQueue.main.async {
                // main Thread
                self.activiateError(self.nameTextField ,self.errorNameLabel , isRequireNameErrorMsg)
                self.activiateError(self.phoneTextField ,self.errorPhoneLabel , isRequirePhoneErrorMsg)
                self.activiateError(self.originTextField ,self.errorOriginLabel, isRequireOriginErrorMsg )
                self.activiateError(self.destinationTextField ,self.errorDestinationLabel , isRequireDestiErrorMsg)
                
            }
            
    
    }
    
    private func activiateError(_ textField:UITextField ,_ errorLabel:errorUILabel , _ errorIsRequire:(isHidden: Bool, errorMsg: String)) {
        
        var isHidden = true
        textField.layer.borderColor = UIColor.lightGray.cgColor
        
        if (errorIsRequire.isHidden == false) {
            isHidden = false
            errorLabel.shake()
            errorLabel.text = errorIsRequire.errorMsg
            textField.layer.borderColor = UIColor.red.cgColor
            
        }
        
        errorLabel.isHidden = isHidden
        
        
    }
    
    // method get textField and check if need to display error msg
    // if need to, the method show error msg according textField
    // that was send to method
    private func handlerErrorEachOneSpearately(_ textField: UITextField) {
        if let mtextField = textField.text {
            if(textField.placeholder == StringUtils.nameTextFieldPLaceHolder) {
                let isRequireNameErrorMsg = ErrorMsgHandler.isNameNeedErrorMsg(msg: mtextField)
                self.activiateError(self.nameTextField ,self.errorNameLabel , isRequireNameErrorMsg)
            }
            else if(textField.placeholder == StringUtils.phoneNumTextFieldPlaceHolder) {
                let isRequirePhoneNumErrorMsg = ErrorMsgHandler.isPhoneNumNeedErrorMsg(msg: mtextField)
                self.activiateError(self.phoneTextField ,self.errorPhoneLabel, isRequirePhoneNumErrorMsg )
                
            }
            else if (textField.placeholder == StringUtils.originTextFieldPlaceHolder) {
                let isRequireOriginErrorMsg = ErrorMsgHandler.isOriginNeedErrorMsg(msg: mtextField)
                self.activiateError(self.originTextField ,self.errorOriginLabel , isRequireOriginErrorMsg)
            }
            else if(textField.placeholder == StringUtils.destinationTextFieldPlaceHolder) {
                let isRequireDestinationErrorMsg = ErrorMsgHandler.isDestinationNeedErrorMsg(msg: mtextField)
                self.activiateError(self.destinationTextField ,self.errorDestinationLabel , isRequireDestinationErrorMsg)
                
                
            }
            
            
            
        }
    }
    
    
    @IBAction func confirmPressed(_ sender: Any) {
        
        let textFieldsTexts = getAllTextFieldsText()
        
        DispatchQueue.global(qos: .userInitiated).async {
            self.handleErrorMsg(textFieldsTexts:textFieldsTexts)
            
            
            DispatchQueue.main.async {
                if(self.isAllErrorsHidden()) {
                    let order = self.getOrder()
                    self.saveOrderToDB(order:order)
                    self.navigationController?.popToRootViewController(animated: true)
                }
                
            }
        }
        
    }
    private func getOrder() ->Order {
       let getTextsFieldsTexts = getAllTextFieldsText()
        
        var order = Order()
        order.name = getTextsFieldsTexts.name
        order.phoneNum = getTextsFieldsTexts.phoneNum
        order.originAddress = getTextsFieldsTexts.origin
        order.destinationAddress = getTextsFieldsTexts.destination
        order.DoucId = String(Date().millisecondsSince1970)
        if(carPressed) {
            order.carOrMotorcycle = Order.Vehicles.car.rawValue
        }else {
            order.carOrMotorcycle = Order.Vehicles.motorcycle.rawValue
        }
        return order
    }
    
    private func saveOrderToDB(order:Order) {
        fireStoreHandler.saveOrder(order:order)
    }
    
    private func  isAllErrorsHidden() -> Bool {
        var isHidden = true
        
        if(!self.errorNameLabel.isHidden || !self.errorPhoneLabel.isHidden || !self.errorOriginLabel.isHidden || !self.errorDestinationLabel.isHidden) {
            isHidden  = false
            
        }
        
        return isHidden
    }
    
    private func initColorIconAndLabel() {
        if(deliveryKindChoosen == StringUtils.car) {
            changeCarIconAndLebalToBlueColor()
            changeMotorcycleIconAndLabelToGrayColor()
            
        }else if (deliveryKindChoosen == StringUtils.motorcycle)  {
            changeMotorcycleIconAndLabelToBlueColor()
            changeCarIconAndLebalToGrayColor()
        }
        
    }
    private func  initOriginAddress() {
        originTextField.text = originAddress
    }
    
    private func initObserverToKeyBoard() {
        // call the 'keyboardWillShow' function when the view controller receive the notification that a keyboard is going to be shown
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        // call the 'keyboardWillHide' function when the view controlelr receive notification that keyboard is going to be hidden
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    
    @objc func keyboardWillShow(notification: NSNotification) {
        
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        else {
            // if keyboard size is not available for some reason, dont do anything
            return
        }
        
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height, right: 0.0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
    
    
    @objc func keyboardWillHide(notification: NSNotification) {
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        
        
        // reset back the content inset to zero after keyboard is gone
        
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
    @IBAction func carBtnPressed(_ sender: UIButton) {
        changeCarIconAndLebalToBlueColor()
        changeMotorcycleIconAndLabelToGrayColor()
        carPressed = true
    }
    
    
    @IBAction func motorcycleBtnPressed(_ sender: UIButton) {
        changeMotorcycleIconAndLabelToBlueColor()
        changeCarIconAndLebalToGrayColor()
        carPressed = false
        
    }
    
    private func changeCarIconAndLebalToGrayColor() {
        carBtn.tintColor = UIColor().myGrayColor()
        upToTenKgLebal.textColor = UIColor().myGrayColor()
        
        
    }
    private func changeCarIconAndLebalToBlueColor() {
        carBtn.tintColor = UIColor().myBlueColor()
        upToTenKgLebal.textColor = UIColor().myBlueColor()
        
        
    }
    private func changeMotorcycleIconAndLabelToGrayColor() {
        motorcycleBtn.tintColor = UIColor().myGrayColor()
        upToFiveKgLabel.textColor = UIColor().myGrayColor()
        
        
    }
    private func changeMotorcycleIconAndLabelToBlueColor() {
        motorcycleBtn.tintColor = UIColor().myBlueColor()
        upToFiveKgLabel.textColor = UIColor().myBlueColor()
        
        
    }
    
}





extension OrderController : UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderColor = UIColor().myBlueColor().cgColor
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        handlerErrorEachOneSpearately(textField)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    
}
