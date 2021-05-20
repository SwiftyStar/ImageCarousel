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
    @State var scrollOffset: CGFloat = 0

    var onImageTap: ImageTapAction?
    var viewModel: ImageCarouselViewModel = ImageCarouselViewModel(imageInset: nil, imageWidth: nil, aspectRatio: nil)
    
    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 0) {
                self.getContent(for: geometry)
            }
            .offset(x: self.scrollOffset)
            .gesture(
                DragGesture()
                    .onChanged { self.draggingChanged($0, geometry: geometry)}
                    .onEnded { self.draggingEnded($0, geometry: geometry)}
            )
            .animation(.linear(duration: 0.2))
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
        self.scrollOffset = self.viewModel.getDragOffset(for: newValue,
                                                         currentOffset: self.scrollOffset,
                                                         imageCount: self.images.count,
                                                         geometry: geometry)
    }
    
    private func draggingEnded(_ finalValue: DragGesture.Value, geometry: GeometryProxy) {
        withAnimation {
            self.scrollOffset = self.viewModel.getFinalDragValue(for: finalValue,
                                                                 scrollOffset: self.scrollOffset,
                                                                 geometry: geometry,
                                                                 imageCount: self.images.count)
        }
    }
}
