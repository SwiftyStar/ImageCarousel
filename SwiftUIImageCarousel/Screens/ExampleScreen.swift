//
//  ContentView.swift
//  SwiftUIImageCarousel
//
//  Created by Jacob Starry on 5/13/21.
//

import SwiftUI

struct ExampleScreen: View {
    private let viewModel = ExampleScreenViewModel()
    @State private var images: [Image] = []
    @State private var carouselDragValue = CarouselDragValue(offset: 0, imageIndex: 0, dragStartDate: nil)
    
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
            ImageCarousel(images: self.$images, carouselDragValue: self.$carouselDragValue, totalImages: self.viewModel.getImageCount())
                .onImageTap(self.imageTapped)
                .withDimensions(inset: 8, aspectRatio: aspectRatio)
                .hasPaging(true)
                .frame(height: UIScreen.main.bounds.width / aspectRatio)
            
            self.titleText
        }
        .onAppear { self.loadImages(currentImage: self.carouselDragValue.imageIndex) }
        .onChange(of: self.carouselDragValue) { self.loadImages(currentImage: $0.imageIndex) }
    }
    
    private func loadImages(currentImage: Int) {
        self.viewModel.lazyLoadImages(currentImage: currentImage) { newImages in
            self.images = newImages
        }
    }
    
    private func imageTapped(_ index: Int?) {
        guard let index = index,
              index < self.images.count
        else { return }
        
        print(index)
    }
}

struct ExampleScreen_Previews: PreviewProvider {
    static var previews: some View {
        ExampleScreen()
    }
}
