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
    
    @Published var imageURLs: [URL] = []
    
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
            
            DispatchQueue.main.async {
                for document in documents {
                    let imagePath = document.data()["path"] as? String ?? ""
                    
                    self.imageService.downloadImagebyURL(path: imagePath) { url in
                        if let url = url {
                            self.imageURLs.append(url)
                        }
                    }
                }
            }
        }
    }
}
