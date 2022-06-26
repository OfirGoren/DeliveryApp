//
//  errorMsgHandler.swift
//  DeliveryApp
//
//  Created by Ofir Goren on 13/06/2022.
//

import Foundation



class ErrorMsgHandler {
    
    
    private static let numberSix = 6
    
    
    
   static func isNameNeedErrorMsg(msg:String) -> (isHidden:Bool , errorMsg:String) {
        var isHidden = true
        var errorMsg = "* "
        if(msg.isEmpty) {
            isHidden = false
            errorMsg += StringUtils.errorEmptyName
            
        }
        
        return (isHidden , errorMsg)
    }
    
    
   static func isEmailNeedErrorMsg(msg:String) -> (isHidden:Bool , errorMsg:String) {
        var isHidden = true
        var errorMsg = "* "
        if(msg.isEmpty) {
            isHidden = false
            errorMsg += StringUtils.errorEmptyEmail
            
        }else if(msg.validateEmail() == false) {
            isHidden  = false
            errorMsg += StringUtils.errorEmailForamt
            
        }
        
        return (isHidden , errorMsg)
    }
    
    
    
   static func isPasswordNeedErrorMsg(msg:String) -> (isHidden:Bool , errorMsg:String) {
       
        var isHidden = true
        var errorMsg = "* "
       
        if(msg.isEmpty) {
            isHidden = false
            errorMsg += StringUtils.errorEmptyPassword
            
        }else if(msg.count < numberSix)  {
            isHidden = false
            errorMsg += StringUtils.errorCountDigitInPassword
            
        }
        
        return (isHidden , errorMsg)
    }
    
    static func isPhoneNumNeedErrorMsg(msg:String)  -> (isHidden:Bool , errorMsg:String) {
        
        var isHidden = true
        var errorMsg = "* "
       
        if(msg.isEmpty) {
            isHidden = false
            errorMsg += StringUtils.errorEmptyPhoneNum
        }
        return (isHidden , errorMsg )
    }
    
    static func isOriginNeedErrorMsg(msg:String)  -> (isHidden:Bool , errorMsg:String) {
        
        var isHidden = true
        var errorMsg = "* "
        
        if(msg.isEmpty) {
            isHidden = false
            errorMsg += StringUtils.errorEmptyOrigin
        }
        return (isHidden , errorMsg )
    }
    
    static func isDestinationNeedErrorMsg(msg:String)  -> (isHidden:Bool , errorMsg:String) {
        
        var isHidden = true
        var errorMsg = "* "
        
        if(msg.isEmpty) {
            isHidden = false
            errorMsg += StringUtils.errorEmptyDestination
        }
        return (isHidden , errorMsg )
    }
}
