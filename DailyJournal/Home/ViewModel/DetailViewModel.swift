//
//  DetailViewModel.swift
//  DailyJournal
//
//  Created by Илья Меркуленко on 11.06.2023.
//

import Foundation
import FirebaseDatabase
import FirebaseStorage
import FirebaseFirestore

class DetailViewModel: ObservableObject {
    
    @Published var images: [ImageModel] = []
    
    private let imageService = FirebaseImageService()
    private let firestore = Firestore.firestore()
    
    func fetchImages() {
        firestore.collection("images").getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching images: \(error.localizedDescription)")
                return
            }

            guard let documents = snapshot?.documents else {
                print("No image documents found.")
                return
            }

            var loadedImages: [ImageModel] = []

            for document in documents {
                let imagePath = document.data()["path"] as? String ?? ""
                let imageModel = ImageModel(id: document.documentID, path: imagePath)
                loadedImages.append(imageModel)
            }

            self.images = loadedImages
        }
    }
    
    func fetchImageData() {
        firestore.collection("images").getDocuments { querySnapshot, error in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                guard let documents = querySnapshot?.documents else { return }
                self.images = documents.compactMap { document in
                    let data = document.data()
                    guard let imageURL = data["path"] as? String else {
                        return nil
                    }
                    return ImageModel(id: document.documentID, path: imageURL)
                }
            }
        }
    }
    
    func fetch() {
        firestore.collection("images").addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }
            
            self.images = documents.map { (queryDocumentSnapshot) -> ImageModel in
                let data = queryDocumentSnapshot.data()
                let id = data["id"] as? String ?? ""
                let path = data["path"] as? String ?? ""
                return ImageModel(id: id, path: path)
            }
            print("\(self.images.count)")
        }
    }
}
