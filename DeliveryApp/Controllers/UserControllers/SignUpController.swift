//
//  SignUpController.swift
//  DeliveryApp
//
//  Created by Ofir Goren on 07/06/2022.
//

import UIKit

class SignUpController: UIViewController  {
    
    
    @IBOutlet weak var titleLabel: UiTitle!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var fullNameTextField: DesignableUITextField!
    @IBOutlet weak var emailTextField: DesignableUITextField!
    @IBOutlet weak var passwordTextField: DesignableUITextField!
    @IBOutlet weak var registerBtn: UiBtn!
    @IBOutlet weak var errorNameLabel: errorUILabel!
    @IBOutlet weak var errorEmailLebal: errorUILabel!
    @IBOutlet weak var customSpinner: CustomSpinner!
    @IBOutlet weak var errorPasswordLabel: errorUILabel!
    
    private let fireBaseAuthHandler = FireBaseAuthHandler()
    private let fireStoreHandler = FireStoreHandler()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initDelegate()
        initErrorHidden()
        initKeyboardObserver()
        
        // Do any additional setup after loading the view.
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    private func initErrorHidden() {
        errorNameLabel.isHidden = true
        errorEmailLebal.isHidden = true
        errorPasswordLabel.isHidden = true
    }
    
    
   
    
    
    private func initDelegate() {
        fullNameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
    }
    
    @IBAction func registerPressed(_ sender: Any) {
        let textFieldsTexts = getTextFieldTexts()
        
        DispatchQueue.global(qos: .userInitiated).async {
            self.handleErrorMsg(textFieldsTexts.name , textFieldsTexts.email , textFieldsTexts.password )
            
            DispatchQueue.main.async {
                if(self.isAllErrorsHidden()) {
                    self.customSpinner.startSpinner()
                    self.createUser()
                    
                    
                }
            }
        }
        
        
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
    
    
    private func initKeyboardObserver() {
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
    
    private func saveUserDB() {
        let textFieldsTexts = getTextFieldTexts()
        let authCurrentId = fireBaseAuthHandler.getCurrentUserId()
        
        if let name = textFieldsTexts.name ,let email = textFieldsTexts.email , let mCurrentId = authCurrentId  {
            
            let profile = Profile(name: name, email: email ,doucumentId: mCurrentId)
            fireStoreHandler.saveUser(profile: profile)
            
            
            
            
        }
    }
    
  
    
    private func getTextFieldTexts() -> (name:String? , email:String? , password:String? ) {
        return (self.fullNameTextField.text , self.emailTextField.text , self.passwordTextField.text)
        
    }
    
    private func createUser() {
        let email = self.emailTextField.text
        let password = self.passwordTextField.text
        
        
        if let mEmail = email , let mPassword = password {
            fireBaseAuthHandler.createUser(email: mEmail, password: mPassword){ result, error in
                self.customSpinner.stopSpinner()
                self.handlerResultSignUp(result , error)
                
            }
            
        }
    }
    
    
    
    private func  isAllErrorsHidden() -> Bool {
        var isHidden = true
        
        if(!self.errorNameLabel.isHidden || !self.errorEmailLebal.isHidden || !self.errorPasswordLabel.isHidden) {
            isHidden  = false
            
        }
        
        return isHidden
    }
    
    private func handlerResultSignUp(_ result:String ,_ error:String?) {
        if(result == StringUtils.isSuccess) {
            self.saveUserDB()
            openAccountNavigation()
            self.navigationController?.popToRootViewController(animated: true)
        }
        
        
    }
    
    private func openAccountNavigation() {
        self.performSegue(withIdentifier: "NavigationTwoIndetifier", sender: self)
        
    }
    
    
    
    
    // check all the textField and if there is need to
    // show errors msg we display
    private func  handleErrorMsg(_ name:String? ,_ email:String? ,_ password:String?) {
        
        // backgorund Thread
        if let checkName = name , let checkEmail = email , let checkPassword = password {
            
            let isRequireNameErrorMsg = ErrorMsgHandler.isNameNeedErrorMsg(msg: checkName)
            let isRequireEmailErrorMsg = ErrorMsgHandler.isEmailNeedErrorMsg(msg: checkEmail)
            let isRequirePasswordErrorMsg = ErrorMsgHandler.isPasswordNeedErrorMsg(msg: checkPassword)
            
            
            DispatchQueue.main.async {
                // main Thread
                self.activiateError(self.fullNameTextField ,self.errorNameLabel , isRequireNameErrorMsg)
                self.activiateError(self.emailTextField ,self.errorEmailLebal, isRequireEmailErrorMsg )
                self.activiateError(self.passwordTextField ,self.errorPasswordLabel , isRequirePasswordErrorMsg)
                
            }
            
            
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
                
                self.activiateError(self.fullNameTextField ,self.errorNameLabel , isRequireNameErrorMsg)
            }
            else if(textField.placeholder == StringUtils.emailTextFieldPLaceHolder) {
                
                let isRequireEmailErrorMsg = ErrorMsgHandler.isEmailNeedErrorMsg(msg: mtextField)
                self.activiateError(self.emailTextField ,self.errorEmailLebal, isRequireEmailErrorMsg )
                
            }else if (textField.placeholder == StringUtils.passwordTextFieldPlaceHolder) {
                let isRequirePasswordErrorMsg = ErrorMsgHandler.isPasswordNeedErrorMsg(msg: mtextField)
                self.activiateError(self.passwordTextField ,self.errorPasswordLabel , isRequirePasswordErrorMsg)
            }
            
            
            
        }
    }
    
    
}




extension SignUpController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // convert textField border color to blue
        
        textField.layer.borderColor = UIColor().myBlueColor().cgColor
        
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        // if textField need to display error msg show That msg
        handlerErrorEachOneSpearately(textField)
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}


