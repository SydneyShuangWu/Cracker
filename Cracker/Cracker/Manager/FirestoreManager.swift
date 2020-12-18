//
//  FirestoreManager.swift
//  Cracker
//
//  Created by Sydney Wu on 2020/12/17.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

typealias FIRFieldValue = Firebase.FieldValue

typealias FIRTimestamp = Timestamp

enum Result<T> {
    
    case success(T)
    
    case failure(Error)
}

enum CollectionName: String {
    
    case crackerUser = "CrackerUser"
    
    case crackerCase = "CrackerCase"
    
    case crackerGame = "CrackerGame"
}

enum FirebaseError: String, Error {
    
    case decode = "Firebase decode error"
}

struct Filter {
    
    let key: String
    
    let value: Any
}

class FirestoreManager {
    
    static let shared = FirestoreManager()
    
    private init() {}
    
    var currentTimestamp: Timestamp {
        
        return Firebase.Timestamp()
    }

    func getCollection(name: CollectionName) -> CollectionReference {
        
        return Firestore.firestore().collection(name.rawValue)
    }
    
    func listen(collectionName: CollectionName, handler: @escaping () -> Void) {
        
        let collection = getCollection(name: collectionName)
        
        collection.addSnapshotListener { _, _ in
  
            handler()
        }
    }
    
    func read<T: Codable>(collectionName: CollectionName, dataType: T.Type, handler: @escaping (Result<[T]>) -> Void) {
        
        let collection = getCollection(name: collectionName)
            
        collection.getDocuments { (querySnapshot, error) in
            
            guard let querySnapshot = querySnapshot else {
                
                handler(.failure(error!))
                
                return
            }
            
            self.decode(dataType, documents: querySnapshot.documents) { (result) in
                
                switch result {
                
                case .success(let data): handler(.success(data))
                    
                case .failure(let error): handler(.failure(error))
                
                }
            }
        }
    }
    
    // Read collection after filtering
    func read<T: Codable>(collectionName: CollectionName, dataType: T.Type, filter: Filter, handler: @escaping (Result<[T]>) -> Void) {
        
        let collection = getCollection(name: collectionName)
        
        collection.whereField(filter.key, isEqualTo: filter.value).getDocuments { (querySnapshot, error) in
            
            guard let querySnapshot = querySnapshot else {
                
                handler(.failure(error!))
                
                return
            }
            
            self.decode(dataType, documents: querySnapshot.documents) { (result) in
                
                switch result {
                
                case .success(let data): handler(.success(data))
                    
                case .failure(let error): handler(.failure(error))
                
                }
            }
        }
    }
    
    // Read document
    func readSingle<T: Codable>(_ doc: DocumentReference, dataType: T.Type, handler: @escaping (Result<T>) -> Void ) {
        
        doc.getDocument { (documentSnapshot, error) in
            
            guard let docSnapshot = documentSnapshot else {
                
                handler(.failure(error!))
                
                return
            }
            
            guard let data = try? docSnapshot.data(as: dataType) else {
                
                handler(.failure(FirebaseError.decode))
                
                return
            }
            
            handler(.success(data))
        }
    }
    
    func decode<T: Codable>(_ dataType: T.Type, documents: [QueryDocumentSnapshot], handler: @escaping (Result<[T]>) -> Void) {
        
        var datas: [T] = []
        
        for document in documents {
            
            guard let data = try? document.data(as: dataType) else {
                
                handler(.failure(FirebaseError.decode))
                
                return
            }
            
            datas.append(data)
        }
        
        handler(.success(datas))
    }
    
    func save<T: Codable>(to document: DocumentReference, data dataType: T) {
        
        let encoder = Firestore.Encoder()
        
        do {
            
            let data = try encoder.encode(dataType)
            
            document.setData(data)
            
        } catch {
            
            print("Firebase save data error: ", error.localizedDescription)
        }
    }
    
    // Update field value
    func update(collectionName: CollectionName, documentId: String, fields: [String:Any]) {
        
        let document = getCollection(name: collectionName).document(documentId)
        
        document.updateData(fields)
    }
}


