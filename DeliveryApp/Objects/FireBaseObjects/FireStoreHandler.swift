//
//  FireStoreHandler.swift
//  DeliveryApp
//
//  Created by Ofir Goren on 15/06/2022.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class FireStoreHandler {
    
    private let db = Firestore.firestore()
    private let fireStoreAuthHandler = FireBaseAuthHandler()
    private let users = "users"
    private let myOrders = "myOrders"
    private let allOrders = "AllOrders"
    
    
    func saveUser(profile:Profile) {
        do {
            
            try db.collection(users).document(profile.doucumentId).setData(from: profile)
            
        } catch let error {
            print("Error writing city to Firestore: \(error)")
        }
        
    }
    
    func saveOrder(order:Order) {
        if let currentUserId = fireStoreAuthHandler.getCurrentUserId() {
            
            do {
                // Saves within a specific user (who was make the request for shippnig)
                try db.collection(users).document(currentUserId).collection(myOrders).document(order.DoucId).setData(from: order)
                // saves within allOrders (lists that holds all orders)
                try db.collection(allOrders).document(order.DoucId).setData(from: order)
            }catch let error {
                print("Error writing city to Firestore: \(error)")
            }
            
        }
        
        
    }
    
    func getMyOrders(info: @escaping (_ :[Order]) -> Void) {
        
        if let mCurrentUserId = fireStoreAuthHandler.getCurrentUserId() {
            var orders:[Order] = []
            db.collection(users).document(mCurrentUserId).collection(myOrders).getDocuments() {  (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        do {
                            let order = try document.data(as: Order.self)
                            orders.append(order)
                        }
                        
                        catch {
                            //  print(err)
                        }
                    }
                    
                    info(orders)
                }
                
            }
        }
    }
    
    
    func updateUrlPhotoDB(url:URL){
        
        if let mCurrentUserId = fireStoreAuthHandler.getCurrentUserId() {
            let userRef = db.collection(users).document(mCurrentUserId)
            
            // Set the "capital" field of the city 'DC'
            userRef.updateData([
                "photoUrl": url.absoluteString
            ]) { err in
                if let err = err {
                    print("Error updating document: \(err)")
                } else {
                    print("Document successfully updated")
                }
            }
            
        }
    }
    
    
    func getUserProfile(userProfile:@escaping (_ :Profile) ->Void) {
        
        if let mCurrentUserId = fireStoreAuthHandler.getCurrentUserId() {
            
            let docRef = db.collection(users).document(mCurrentUserId)
            
            docRef.getDocument(as: Profile.self) { result in
                switch result {
                case .success(let profile):
                    userProfile(profile)
                    print("profile: \(profile)")
                case .failure(let error):
                    // A `City` value could not be initialized from the DocumentSnapshot.
                    print("Error decoding profile: \(error)")
                }
            }
        }
        
        
        
    }
    
    func getAllOrders(_ ordersDB:@escaping (_:[Order]) -> Void) {
        
        
        var orders:[Order] = []
        db.collection(allOrders).getDocuments() {  (querySnapshot, err) in
            DispatchQueue.global(qos: .userInitiated).async {
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    
                    for document in querySnapshot!.documents {
                        do {
                            let order = try document.data(as: Order.self)
                            orders.append(order)
                        }
                        
                        catch {
                            
                        }
                    }
                    DispatchQueue.main.async {
                        ordersDB(orders)
                        print("This is run on the main queue, after the previous code in outer block")
                    }
                    
                }
                
                
            }
            
            
        }
    }
    
    func removeOrderFromAllOrders(_ order:Order) {
        
        db.collection(allOrders).document(order.DoucId).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
            
            
        }
        
        
        
    }
}
