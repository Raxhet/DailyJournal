//
//  FirebaseImageService.swift
//  DailyJournal
//
//  Created by Илья Меркуленко on 11.06.2023.
//

import Foundation
import FirebaseStorage
import FirebaseFirestore
import UIKit

class FirebaseImageService {
    
    let storage = Storage.storage()
    
    func uploadImage(_ image: UIImage, completion: @escaping (Error?) -> Void) {
        
        let path = "images/\(UUID().uuidString).jpg"
        let storageRef = storage.reference()
        let imageRef = storageRef.child(path)

        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            completion(nil)
            return
        }

        imageRef.putData(imageData, metadata: nil) { (metadata, error) in
            guard let metadata = metadata else {
                completion(error)
                return
            }
            if error == nil {
                let db = Firestore.firestore()
                db.collection("images").document().setData(["path": path])
            }
//            print("Metadata size: \(metadata.size)")
        }
    }
    
    func downloadImage(at path: String, completion: @escaping (UIImage?, Error?) -> Void) {
        
        let storageRef = storage.reference(withPath: path)
        
        storageRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if let error = error {
                completion(nil, error)
            } else if let data = data, let image = UIImage(data: data) {
                completion(image, nil)
            } else {
                completion(nil, nil)
            }
        }
    }
    
    func uploadImages(_ images: [UIImage], completion: @escaping (Error?) -> Void) {
        let storageRef = storage.reference()
        
        let group = DispatchGroup()
        
        for image in images {
            group.enter()
            
            guard let imageData = image.jpegData(compressionQuality: 0.8) else {
                group.leave()
                continue
            }
            
            let imageRef = storageRef.child("images/\(UUID().uuidString).jpg")
            
            imageRef.putData(imageData, metadata: nil) { (_, error) in
                if let error = error {
                    completion(error)
                } else {
                    group.leave()
                }
            }
        }
        
        group.notify(queue: .main) {
            completion(nil)
        }
    }
}
