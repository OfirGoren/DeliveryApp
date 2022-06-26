//
//  fireBaseStorageHandler.swift
//  DeliveryApp
//
//  Created by Ofir Goren on 19/06/2022.
//

import Foundation
import FirebaseStorage

class fireBaseStorageHandler {


  private let storage = Storage.storage()
    private let storageRef: StorageReference
    
    init() {
        self.storageRef = storage.reference()
        
    }
    
    func uploadImage(url:URL , urlStoragePic: @escaping (_ :URL) -> Void) {
        
        
        // File located on disk
        let localFile = url

        // Create a reference to the file you want to upload
        
        let riversRef = self.storageRef.child("images/\(Date().millisecondsSince1970)")

        // Upload the file to the path "images/rivers.jpg"
         riversRef.putFile(from: localFile, metadata: nil) { metadata, error in
          guard let _ = metadata else {

            return
          }
          // Metadata contains file metadata such as size, content-type.
            // let size = metadata.size
          // You can also access to download URL after upload.
          riversRef.downloadURL { (url, error) in
            guard let downloadURL = url else {
              return
            }
              urlStoragePic(downloadURL)
          }
        }
        
    }
    

}
