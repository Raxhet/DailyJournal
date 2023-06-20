//
//  HomeView.swift
//  DailyJournal
//
//  Created by Илья Меркуленко on 11.06.2023.
//

import SwiftUI

struct HomeView: View {
    
    @State var selectedImages: [UIImage] = []
    @State var showImagePicker: Bool = false
    @StateObject var vm = DetailViewModel()

    var body: some View {
        VStack {
            ScrollView(.horizontal) {
                ForEach(vm.imageURLs, id: \.self) { image in
                    AsyncImage(url: URL(string: image.absoluteString)) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        case .failure(let error):
                            Image(systemName: "exclamationmark.icloud")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                            Text("Failed to load image: \(error.localizedDescription)")
                                .foregroundColor(.red)
                        @unknown default:
                            EmptyView()
                        }
                    }
                }
            }
            .task {
                vm.fetchImages()
            }
            
            Button(action: {
                showImagePicker = true
            }) {
                Text("Select Images")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            
            ScrollView(.horizontal) {
                HStack {
                    ForEach(selectedImages, id: \.self) { image in
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200, height: 200)
                            .padding(5)
                    }
                }
            }
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(selectedImages: $selectedImages, showImagePicker: $showImagePicker)
        }
    }
}


struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
