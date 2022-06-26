

import Foundation
import FirebaseAuth
class FireBaseAuthHandler {
    
    let auth = Auth.auth()
    
    func createUser(email:String , password:String , info: @escaping (_ :String , _:String?) -> Void) {
        auth.createUser(withEmail: email, password: password) {  authResult, error in
            if(error == nil) {
                info(StringUtils.isSuccess , nil)
            }else {
                print(error.debugDescription)
                info(StringUtils.isFailed , error.debugDescription)
            }
            
        }
        
    }
    
    
    func signIn(email:String , password:String , info: @escaping (_ :String) -> Void) {
        auth.signIn(withEmail: email, password: password) { [weak self] authResult, error in
            guard self != nil else { return }
            
            if(error == nil) {
                info(StringUtils.isSuccess)
            }else {
                print(error.debugDescription)
                info(StringUtils.isFailed)
            }
            
        }
        
        
    }
    
    func isUserAlreadyConnected(info: @escaping (_ :String) -> Void) {
        
        if auth.currentUser != nil {
            info(StringUtils.userConnecting)
        } else {
            info(StringUtils.userIsntConnecting)
        }
        
        
    }
    
    func signOut() {
        do {
            try auth.signOut()
        }catch _ {
            
        }
        
    }
    
    func getCurrentUserId() ->String? {
        
      return  auth.currentUser?.uid
        
    }
    
}


