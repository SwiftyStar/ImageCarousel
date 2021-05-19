//
//  ImageCarousel.swift
//  SwiftUIImageCarousel
//
//  Created by Jacob Starry on 5/13/21.
//

import SwiftUI

struct ImageCarousel: View {
    typealias ImageTapAction = ((AnyHashable) -> Void)

    @Binding private var images: [IdentifiableImage]
    @State private var scrollOffset: CGFloat = 0

    private let onImageTap: ImageTapAction?
    private let backgroundColor: Color
    private let viewModel: ImageCarouselViewModel
    
    init(images: Binding<[IdentifiableImage]>) {
        self._images = images
        self.onImageTap = nil
        self.backgroundColor = Color.clear
        self.viewModel = ImageCarouselViewModel(imageInset: nil, imageWidth: nil)
    }
    
    private init(images: Binding<[IdentifiableImage]>, backgroundColor: Color, imageWidth: CGFloat?, imageInset: CGFloat?, onImageTap: ImageTapAction?) {
        self._images = images
        self.backgroundColor = backgroundColor
        self.viewModel = ImageCarouselViewModel(imageInset: imageInset, imageWidth: imageWidth)
        self.onImageTap = onImageTap
    }
    
    private var carousel: some View {
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
    
    var body: some View {
        ZStack {
            self.backgroundColor
            self.carousel
        }
    }
    
    private func getContent(for geometry: GeometryProxy) -> some View {
        ForEach(self.images) { image in
            VStack {
                Spacer()
                    .frame(minHeight: 0)
                
                if let inset = self.viewModel.getImageInset() {
                    self.getInsetImage(image, inset: inset, geometry: geometry)
                } else {
                    self.getImage(image, geometry: geometry)
                }
                
                Spacer()
                    .frame(minHeight: 0)
            }
        }
    }
    
    private func getInsetImage(_ image: IdentifiableImage, inset: CGFloat, geometry: GeometryProxy) -> some View {
        HStack(alignment: .top) {
            Spacer()
                .frame(width: inset)
            image.image
                .resizable()
                .frame(width: self.viewModel.getImageWidth(for: geometry), height: geometry.size.height)
                .aspectRatio(contentMode: .fill)
            Spacer()
                .frame(width: inset)
        }
        .contentShape(Rectangle())
        .onTapGesture { self.onImageTap?(image.id) }
    }
    
    private func getImage(_ image: IdentifiableImage, geometry: GeometryProxy) -> some View {
        image.image
            .resizable()
            .frame(width: self.viewModel.getImageWidth(for: geometry), height: geometry.size.height)
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
    
    func onImageTap(_ action: ImageTapAction?) -> ImageCarousel {
        ImageCarousel(images: self.$images,
                      backgroundColor: self.backgroundColor,
                      imageWidth: self.viewModel.getImageWidth(),
                      imageInset: self.viewModel.getImageInset(),
                      onImageTap: action)
    }
    
    func imageWidth(_ width: CGFloat?) -> ImageCarousel {
        ImageCarousel(images: self.$images,
                      backgroundColor: self.backgroundColor,
                      imageWidth: width,
                      imageInset: self.viewModel.getImageInset(),
                      onImageTap: self.onImageTap)
    }
    
    func imageInset(_ inset: CGFloat?) -> ImageCarousel {
        ImageCarousel(images: self.$images,
                      backgroundColor: self.backgroundColor,
                      imageWidth: self.viewModel.getImageWidth(),
                      imageInset: inset,
                      onImageTap: self.onImageTap)
    }
    
    func backgroundColor(_ color: Color) -> ImageCarousel {
        ImageCarousel(images: self.$images,
                      backgroundColor: color,
                      imageWidth: self.viewModel.getImageWidth(),
                      imageInset: self.viewModel.getImageInset(),
                      onImageTap: self.onImageTap)
    }
}
