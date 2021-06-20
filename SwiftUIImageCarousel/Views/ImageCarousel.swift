//
//  ImageCarousel.swift
//  SwiftUIImageCarousel
//
//  Created by Jacob Starry on 5/13/21.
//

import SwiftUI

struct ImageCarousel: View {
    typealias ImageTapAction = ((Int?) -> Void)
    
    @Binding var images: [Image]
    @Binding var carouselDragValue: CarouselDragValue
    let totalImages: Int

    private let viewModel: ImageCarouselViewModel = ImageCarouselViewModel()
    
    var onImageTap: ImageTapAction?
    var hasPaging: Bool = false
    var imageDimensions = ImageDimensions(width: nil, inset: nil, aspectRatio: nil)
    
    init(images: Binding<[Image]>, carouselDragValue: Binding<CarouselDragValue>, totalImages: Int) {
        self._images = images
        self.totalImages = totalImages
        self._carouselDragValue = carouselDragValue
    }
    
    private var carousel: some View {
        GeometryReader { geometry in
            LazyHStack(spacing: 0) {
                self.getContent(for: geometry)
                    .offset(x: self.carouselDragValue.offset)
            }
            .gesture(
                DragGesture(minimumDistance: 0.0)
                    .onChanged { self.draggingChanged($0, geometry: geometry) }
                    .onEnded { self.draggingEnded($0, geometry: geometry)}
            )
        }
    }
    
    var body: some View {
        VStack {
            self.carousel
            
            if self.hasPaging {
                Spacer()
                    .frame(height: 8)
                CarouselPagingView(carouselDragValue: self.$carouselDragValue, totalImages: self.totalImages)
                    .animation(.none)
            }
        }
    }
    
    private func getContent(for geometry: GeometryProxy) -> some View {
        ForEach(0..<self.totalImages) { index in
            ZStack {
                let haveImage = index < self.images.count
                if haveImage {
                    self.getImageView(at: index, geometry: geometry)
                }
                
                self.getImageView(at: nil, geometry: geometry)
                    .redacted(reason: .placeholder)
                    .opacity(haveImage ? 0 : 1)
            }
        }
    }
    
    private func getImageView(at index: Int?, geometry: GeometryProxy) -> some View {
        VStack {
            Spacer(minLength: 0)
            
            if let inset = self.imageDimensions.inset {
                self.getInsetImage(at: index, inset: inset, geometry: geometry)
            } else {
                self.getImage(at: index, geometry: geometry)
            }
            
            Spacer(minLength: 0)
        }
    }
    
    private func getInsetImage(at index: Int?, inset: CGFloat, geometry: GeometryProxy) -> some View {
        let image: Image
        if let imageIndex = index {
            image = self.images[imageIndex]
        } else {
            image = Image("Kitten1") // some placeholder
        }
        
        return HStack(alignment: .top) {
            let size = self.viewModel.getImageSize(for: geometry, imageDimensions: self.imageDimensions)
            let width = size.width
            let height = size.height
            
            Spacer()
                .frame(width: inset)
            image
                .resizable()
                .frame(width: width, height: height)
                .aspectRatio(contentMode: .fill)
            Spacer()
                .frame(width: inset)
        }
        .contentShape(Rectangle())
        .onTapGesture { self.onImageTap?(index) }
    }
    
    private func getImage(at index: Int?, geometry: GeometryProxy) -> some View {
        let size = self.viewModel.getImageSize(for: geometry, imageDimensions: self.imageDimensions)
        let width = size.width
        let height = size.height
        
        let image: Image
        if let imageIndex = index {
            image = self.images[imageIndex]
        } else {
            image = Image("Kitten1") // some placeholder
        }
        
        return image
            .resizable()
            .frame(width: width, height: height)
            .aspectRatio(contentMode: .fill)
            .onTapGesture { self.onImageTap?(index) }
    }
    
    private func draggingChanged(_ newValue: DragGesture.Value, geometry: GeometryProxy) {
        let newDragValue = self.viewModel.getDragValue(for: newValue,
                                                       carouselDragValue: self.carouselDragValue,
                                                       imageCount: self.totalImages,
                                                       geometry: geometry,
                                                       imageDimensions: self.imageDimensions)
        
        self.carouselDragValue = newDragValue
    }
    
    private func draggingEnded(_ finalValue: DragGesture.Value, geometry: GeometryProxy) {
        let finalDragValue = self.viewModel.getFinalDragValue(for: finalValue,
                                                              carouselDragValue: self.carouselDragValue,
                                                              geometry: geometry,
                                                              imageCount: self.totalImages,
                                                              imageDimensions: self.imageDimensions)

        withAnimation(.linear(duration: 0.2)) { self.carouselDragValue = finalDragValue }
    }
}
