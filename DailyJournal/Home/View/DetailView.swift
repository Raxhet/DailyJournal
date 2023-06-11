//
//  DetailView.swift
//  DailyJournal
//
//  Created by Илья Меркуленко on 11.06.2023.
//

import SwiftUI


struct DetailView: View {
    
    @StateObject var vm = DetailViewModel()
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))]) {
                ForEach(vm.images) { image in
                    AsyncImage(url: URL(string: image.path)) { phase in
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
        }
        .onAppear {
//            vm.fetchImages()
        }
        .padding()
        
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView()
    }
}
