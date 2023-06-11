//
//  ImagePicker.swift
//  DailyJournal
//
//  Created by Илья Меркуленко on 11.06.2023.
//

import Foundation
import SwiftUI
import UIKit
import PhotosUI

struct ImagePicker: UIViewControllerRepresentable {
    
    @Binding var selectedImages: [UIImage]
    @Binding var showImagePicker: Bool
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        configuration.selection = .ordered                                                                              
        configuration.selectionLimit = 0
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = context.coordinator
        
        return picker
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self, FirebaseImageService ())
    }
    
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let parent: ImagePicker
        var service: FirebaseImageService
        
        init(_ parent: ImagePicker, _ service: FirebaseImageService) {
            self.parent = parent
            self.service = service
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            parent.selectedImages.removeAll()
            
            for result in results {
                if result.itemProvider.canLoadObject(ofClass: UIImage.self) {
                    result.itemProvider.loadObject(ofClass: UIImage.self) { (image, error) in
                        if let image = image as? UIImage {
                            DispatchQueue.main.async {
                                self.parent.selectedImages.append(image)
                                
                                self.service.uploadImage(image) { error in
                                    print(error?.localizedDescription ?? "xz")
                                }
                            }
                        }
                    }
                }
            }
            print("picker func: \(results.count)")
            parent.showImagePicker = false
        }
    }
}
