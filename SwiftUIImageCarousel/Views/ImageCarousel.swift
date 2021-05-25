//
//  ImageCarousel.swift
//  SwiftUIImageCarousel
//
//  Created by Jacob Starry on 5/13/21.
//

import SwiftUI

struct ImageCarousel: View {
    typealias ImageTapAction = ((AnyHashable) -> Void)

    @Binding var images: [IdentifiableImage]
    @State var currentImage: Int = 0
    @State var offset: CGFloat = 0
    
    init(images: Binding<[IdentifiableImage]>) {
        self._images = images
    }
    
    var onImageTap: ImageTapAction?
    var hasPaging: Bool = false
    var viewModel: ImageCarouselViewModel = ImageCarouselViewModel(imageInset: nil, imageWidth: nil, aspectRatio: nil)
    
    private var carousel: some View {
        GeometryReader { geometry in
            HStack(spacing: 0) {
                self.getContent(for: geometry)
            }
            .offset(x: self.offset)
            .gesture(
                DragGesture()
                    .onChanged { self.draggingChanged($0, geometry: geometry)}
                    .onEnded { self.draggingEnded($0, geometry: geometry)}
            )
            .animation(.linear(duration: 0.2))
        }
    }
    
    var body: some View {
        VStack {
            self.carousel

            if self.hasPaging {
                Spacer()
                    .frame(height: 8)
                CarouselPagingView(images: self.$images, currentImage: self.$currentImage)
            }
        }
    }
    
    private func getContent(for geometry: GeometryProxy) -> some View {
        ForEach(self.images) { image in
            VStack {
                Spacer(minLength: 0)
                
                if let inset = self.viewModel.getImageInset() {
                    self.getInsetImage(image, inset: inset, geometry: geometry)
                } else {
                    self.getImage(image, geometry: geometry)
                }
                
                Spacer(minLength: 0)
            }
        }
    }
    
    private func getInsetImage(_ image: IdentifiableImage, inset: CGFloat, geometry: GeometryProxy) -> some View {
        HStack(alignment: .top) {
            let size = self.viewModel.getImageSize(for: geometry)
            let width = size.width
            let height = size.height
            
            Spacer()
                .frame(width: inset)
            image.image
                .resizable()
                .frame(width: width, height: height)
                .aspectRatio(contentMode: .fill)
            Spacer()
                .frame(width: inset)
        }
        .contentShape(Rectangle())
        .onTapGesture { self.onImageTap?(image.id) }
    }
    
    private func getImage(_ image: IdentifiableImage, geometry: GeometryProxy) -> some View {
        let size = self.viewModel.getImageSize(for: geometry)
        let width = size.width
        let height = size.height
        
        return image.image
            .resizable()
            .frame(width: width, height: height)
            .aspectRatio(contentMode: .fill)
            .onTapGesture { self.onImageTap?(image.id) }
    }
    
    private func draggingChanged(_ newValue: DragGesture.Value, geometry: GeometryProxy) {
        let carouselDragValue = self.viewModel.getDragValue(for: newValue,
                                                             currentOffset: self.offset,
                                                             imageCount: self.images.count,
                                                             geometry: geometry)
        
        self.offset = carouselDragValue.offset
        self.currentImage = carouselDragValue.currentImage
    }
    
    private func draggingEnded(_ finalValue: DragGesture.Value, geometry: GeometryProxy) {
        let carouselDragValue = self.viewModel.getFinalDragValue(for: finalValue,
                                                                 scrollOffset: self.offset,
                                                                 geometry: geometry,
                                                                 imageCount: self.images.count)
        
        self.currentImage = carouselDragValue.currentImage
        withAnimation {
            self.offset = carouselDragValue.offset
        }
    }
}
