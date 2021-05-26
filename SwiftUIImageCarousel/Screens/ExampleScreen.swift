//
//  ContentView.swift
//  SwiftUIImageCarousel
//
//  Created by Jacob Starry on 5/13/21.
//

import SwiftUI

struct ExampleScreen: View {
    private let viewModel = ExampleScreenViewModel()
    @State private var images: [IdentifiableImage] = []
    @State private var currentImage = 0
    
    private var titleText: some View {
        Group {
            Spacer()
                .frame(height: 24)
            Text("Some Kitties")
            Spacer()
        }
    }
    
    var body: some View {
        VStack {
            let aspectRatio: CGFloat = 4 / 3
            ImageCarousel(images: self.$images, currentImage: self.$currentImage, totalImages: self.viewModel.getImageCount())
                .onImageTap { print($0) }
                .withDimensions(inset: 8, aspectRatio: aspectRatio)
                .hasPaging(true)
                .frame(height: UIScreen.main.bounds.width / aspectRatio)
            
            self.titleText
        }
        .onAppear { self.loadImages(currentImage: self.currentImage) }
        .onChange(of: self.currentImage) { self.loadImages(currentImage: $0) }
    }
    
    private func loadImages(currentImage: Int) {
        self.viewModel.lazyLoadImages(currentImage: currentImage) { newImages in
            self.images = newImages
        }
    }
}

struct ExampleScreen_Previews: PreviewProvider {
    static var previews: some View {
        ExampleScreen()
    }
}
