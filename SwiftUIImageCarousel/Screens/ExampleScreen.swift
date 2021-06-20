//
//  ContentView.swift
//  SwiftUIImageCarousel
//
//  Created by Jacob Starry on 5/13/21.
//

import SwiftUI

struct ExampleScreen: View {
    @ObservedObject private var viewModel = ExampleScreenViewModel()
    @State private var carouselDragValue = CarouselDragValue(offset: 0,
                                                             imageIndex: 0,
                                                             dragStartDate: nil,
                                                             previousOffset: 0,
                                                             previousImageIndex: 0)
    
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
            ImageCarousel(images: self.$viewModel.loadedImages, carouselDragValue: self.$carouselDragValue, totalImages: self.viewModel.getImageCount())
                .onImageTap(self.imageTapped)
                .withDimensions(inset: 8, aspectRatio: aspectRatio)
                .hasPaging(true)
                .frame(height: UIScreen.main.bounds.width / aspectRatio)
            
            self.titleText
        }
        .onAppear { self.viewModel.lazyLoadImages(currentImage: self.carouselDragValue.imageIndex) }
        .onChange(of: self.carouselDragValue) { self.viewModel.lazyLoadImages(currentImage: $0.imageIndex) }
    }
    
    private func imageTapped(_ index: Int?) {
        guard let index = index,
              index < self.viewModel.loadedImages.count
        else { return }
        
        print(index)
    }
}

struct ExampleScreen_Previews: PreviewProvider {
    static var previews: some View {
        ExampleScreen()
    }
}
