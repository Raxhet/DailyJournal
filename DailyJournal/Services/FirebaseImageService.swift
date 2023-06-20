import Foundation
import FirebaseStorage
import FirebaseFirestore
import UIKit

class FirebaseImageService {
    
    let storage = Storage.storage()
    
    func uploadImage(_ image: UIImage, completion: @escaping (Error?) -> ()) {
        let storageRef = storage.reference()
        
        let path = "images/\(UUID().uuidString).jpeg"
        let imageRef = storageRef.child(path)
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"

        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            completion(nil)
            return
        }

        imageRef.putData(imageData, metadata: metaData) { (metadata, error) in
            guard metadata != nil else {
                completion(error)
                return
            }
            if error == nil {
                let db = Firestore.firestore()
                db.collection("images").document().setData(["path": path])
            }
        }
    }
    
    func downloadImage(at path: String, completion: @escaping (UIImage?) -> Void) {
        
        let storageRef = storage.reference(withPath: path)
        
        storageRef.getData(maxSize: 3 * 1024 * 1024) { data, error in
            if let error = error {
                print("Error downloading image: \(error.localizedDescription)")
                completion(nil)
            } else if let data = data, let image = UIImage(data: data) {
                print("downloadImage size: \(image.size), and data count: \(data.count)")
                completion(image)
            } else {
                completion(nil)
            }
        }
    }
    
    func downloadImagebyURL(path: String, completion: @escaping (URL?) -> Void) {
        let storageRef = storage.reference().child(path)
        
        storageRef.downloadURL { url, err in
            if let err = err {
                print("Download error: \(err.localizedDescription)")
                completion(nil)
            } else {
                completion(url)
            }
        }
    }
}
