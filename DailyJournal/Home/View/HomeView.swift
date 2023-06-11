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
    @State var vm = DetailViewModel()
    let service = FirebaseImageService()
    
    var body: some View {
        VStack {
            ScrollView(.horizontal) {
                Text("\(vm.images.count)")
                ForEach(vm.images) { image in
                    AsyncImage(url: URL(string: image.path))
                }
            }
            .onAppear {
                self.vm.fetchImages()
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
