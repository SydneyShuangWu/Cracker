//
//  FirebaseStorageManager.swift
//  Cracker
//
//  Created by Sydney Wu on 2020/12/17.
//

import Foundation
import FirebaseStorage

enum StorageFolder: String {
    
    case caseImage = "CaseImage"
    
    case characterImage = "CharacterImage"
    
    case userImage = "UserImage"
}

class StorageManager {
    
    static let shared = StorageManager()
    
    private init() {}
    
    func uploadImage(image: UIImage, folder: StorageFolder, id: String, handler: @escaping (Result<String>) -> Void) {
        
        let storageRef = Storage.storage().reference().child(folder.rawValue).child(id).child(UUID().uuidString)
        
        guard let data = image.jpegData(compressionQuality: 0.7) else { return }
        
        storageRef.putData(data, metadata: nil) { (data, error) in
            
            if error != nil {
                
                handler(.failure(error!))
                
                print("Storage putData error: \(error!.localizedDescription)")
                
                return
            }
            
            storageRef.downloadURL { (url, error) in
                
                if error != nil {
                    
                    handler(.failure(error!))
                    
                    print("Storage download error: \(error!.localizedDescription)")
                    
                    return
                }
                
                guard let url = url else {
                    
                    handler(.failure(error!))
                    
                    print("Storage download url error: \(error!.localizedDescription)")
                    
                    return
                }
            
                handler(.success(url.absoluteString))
            }
        }
    }
}

