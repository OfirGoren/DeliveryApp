//
//  ViewController.swift
//  DeliveryApp
//
//  Created by Ofir Goren on 06/06/2022.
//

import UIKit

class ViewController: UIViewController {
    
    
    
    @IBOutlet weak var titleLabel: UiTitle!
    @IBOutlet weak var emailTextField: DesignableUITextField!
    @IBOutlet weak var passwordTextField: DesignableUITextField!
    @IBOutlet weak var customSpinner: CustomSpinner!
    @IBOutlet weak var errorEmailLabel: errorUILabel!
    @IBOutlet weak var errorPasswordLabel: errorUILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var errorOccurredLabel: errorUILabel!
    
    private let fireBaseAuthHandler = FireBaseAuthHandler()
    
    override func loadView() {
        super.loadView()
        checkUserAlreadyConnecded()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initDelegate()
        initErrorMsgHidden()
        initKeyboardObserver()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    
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
    
    private func checkUserAlreadyConnecded() {
        fireBaseAuthHandler.isUserAlreadyConnected() { [weak self] result in
            if(result == StringUtils.userConnecting) {
                self?.moveToAccountPage()
            }
            
            
        }
        
    }
    
    
    private func  initErrorMsgHidden() {
        self.errorEmailLabel.isHidden = true
        self.errorPasswordLabel.isHidden = true
        errorOccurredLabel.isHidden = true
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
    
    
    @IBAction func logInPressed(_ sender: Any) {
        let email = emailTextField.text
        let password = passwordTextField.text
        
        DispatchQueue.global(qos: .userInitiated).async {
            self.handleErrorMsg(email , password)
            
            DispatchQueue.main.async {
                if(self.isAllErrorsHidden()) {
                    self.customSpinner.startSpinner()
                    self.signIn()
                    
                    
                }
            }
        }
        
        
    }
    
    private func signIn() {
        let email = emailTextField.text
        let password = passwordTextField.text
        
        if let mEmail = email , let mPassword = password {
            fireBaseAuthHandler.signIn(email: mEmail, password: mPassword) { [weak self] result in
                self?.customSpinner.stopSpinner()
                if (result == StringUtils.isSuccess) {
                    self?.moveToAccountPage()
                }else {
                    self?.errorOccurredLabel.isHidden = false
                    self?.errorOccurredLabel.shake()
                }
                
            }
        }
        
        
    }
    
    
    private func  moveToAccountPage() {
        performSegue(withIdentifier: "InsertToAccountIdentifier", sender: self)
        
        
    }
    
    private func  isAllErrorsHidden() -> Bool {
        var isHidden = true
        
        if(!self.errorEmailLabel.isHidden || !self.errorPasswordLabel.isHidden) {
            isHidden  = false
            
        }
        
        return isHidden
    }
    
    
    
    // check all the textField and if there is need to
    // show errors msg we display
    private func  handleErrorMsg(_ email:String? ,_ password:String?) {
        
        // backgorund Thread
        if let checkEmail = email , let checkPassword = password {
            
            
            let isRequireEmailErrorMsg = ErrorMsgHandler.isEmailNeedErrorMsg(msg: checkEmail)
            let isRequirePasswordErrorMsg = ErrorMsgHandler.isPasswordNeedErrorMsg(msg: checkPassword)
            
            
            DispatchQueue.main.async {
                // main Thread
                
                self.activiateError(self.emailTextField ,self.errorEmailLabel, isRequireEmailErrorMsg )
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
            
            if(textField.placeholder == StringUtils.emailTextFieldPLaceHolder) {
                
                let isRequireEmailErrorMsg = ErrorMsgHandler.isEmailNeedErrorMsg(msg: mtextField)
                
                self.activiateError(self.emailTextField ,self.errorEmailLabel, isRequireEmailErrorMsg )
                
            }else if (textField.placeholder == StringUtils.passwordTextFieldPlaceHolder) {
                let isRequirePasswordErrorMsg = ErrorMsgHandler.isPasswordNeedErrorMsg(msg: mtextField)
                self.activiateError(self.passwordTextField ,self.errorPasswordLabel , isRequirePasswordErrorMsg)
            }
            
            
            
        }
    }

    
    
    
    
    
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    
    
    private func initDelegate() {
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
    }
    
    
}



extension ViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // convert textField border color to blue
        textField.layer.borderColor = UIColor().myBlueColor().cgColor
        // hidden the error occured msg
        self.errorOccurredLabel.isHidden = true
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        handlerErrorEachOneSpearately(textField)
    }
    
}


