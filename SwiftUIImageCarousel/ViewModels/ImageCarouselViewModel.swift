//
//  ImageCarouselViewModel.swift
//  SwiftUIImageCarousel
//
//  Created by Jacob Starry on 5/16/21.
//

import SwiftUI

final class ImageCarouselViewModel {
    private let imageInset: CGFloat?
    private let imageWidth: CGFloat?
    private let aspectRatio: CGFloat?
    private var lastTranslationWidth: CGFloat = 0
    
    init(imageInset: CGFloat?, imageWidth: CGFloat?, aspectRatio: CGFloat?) {
        self.imageInset = imageInset
        self.imageWidth = imageWidth
        self.aspectRatio = aspectRatio
    }
    
    func getImageInset() -> CGFloat? {
        self.imageInset
    }
        
    func getImageSize(for geometry: GeometryProxy) -> CGSize {
        let totalInset = 2 * (self.imageInset ?? 0)
        let defaultWidth = geometry.size.width - totalInset
        let width = self.imageWidth ?? defaultWidth
        
        let maxHeight = geometry.size.height
        let height: CGFloat
        if let ratio = self.aspectRatio {
            let proposedHeight = width / ratio
            let safeHeight = min(maxHeight, proposedHeight)
            height = safeHeight
        } else {
            height = maxHeight
        }
        
        return CGSize(width: width, height: height)
    }
    
    func getDragValue(for dragValue: DragGesture.Value, currentOffset: CGFloat, imageCount: Int, geometry: GeometryProxy) -> CarouselDragValue {
        let newTranslationWidth = self.getNewTranslationWidth(for: dragValue)
        self.lastTranslationWidth = dragValue.translation.width
        
        let newOffset = currentOffset + newTranslationWidth
        let constrainedOffset = self.getConstrainedOffset(newOffset,
                                                          imageCount: imageCount,
                                                          geometry: geometry,
                                                          isDragging: true)
        let currentImage = self.getCurrentImage(for: constrainedOffset,
                                                geometry: geometry,
                                                imageCount: imageCount)
        
        return CarouselDragValue(offset: constrainedOffset, currentImage: currentImage)
    }
    
    func getFinalDragValue(for dragValue: DragGesture.Value, scrollOffset: CGFloat, geometry: GeometryProxy, imageCount: Int) -> CarouselDragValue {
        let totalWidthOfEachImage = self.getTotalWidthOfEachImage(for: geometry)
        let safeWidth = max(totalWidthOfEachImage, 1) // Avoid division by 0 for edge cases
        
        let finalTranslationWidth = self.getNewTranslationWidth(for: dragValue)
        self.lastTranslationWidth = 0
        
        let finalScrollOffset = scrollOffset + finalTranslationWidth
        let numberOfImagesScrolled = finalScrollOffset / safeWidth
        let roundedNumberOfImages = round(Double(numberOfImagesScrolled))
        
        let totalOffset = CGFloat(roundedNumberOfImages) * totalWidthOfEachImage
        let constrainedOffset = self.getConstrainedOffset(totalOffset,
                                                          imageCount: imageCount,
                                                          geometry: geometry,
                                                          isDragging: false)
        let currentImage = self.getCurrentImage(for: constrainedOffset,
                                                geometry: geometry,
                                                imageCount: imageCount)
        
        return CarouselDragValue(offset: constrainedOffset, currentImage: currentImage)
    }
    
    private func getCurrentImage(for offset: CGFloat, geometry: GeometryProxy, imageCount: Int) -> Int {
        let totalWidthOfEachImage = self.getTotalWidthOfEachImage(for: geometry)
        let safeWidth = max(totalWidthOfEachImage, 1) // Avoid division by 0
        let numberOfImagesScrolled = -offset / safeWidth // Scrolling forward gives negative offset
        return Int(round(Double(numberOfImagesScrolled)))
    }
    
    private func getConstrainedOffset(_ offset: CGFloat, imageCount: Int, geometry: GeometryProxy, isDragging: Bool) -> CGFloat {
        let totalWidthOfEachImage = self.getTotalWidthOfEachImage(for: geometry)
        let maxImagesToBeOffset = imageCount - 1 // If we offset N - 1 images, then the last will be visible
        
        var minOffset = -(totalWidthOfEachImage * CGFloat(maxImagesToBeOffset))
        var maxOffset = CGFloat.zero
        
        if isDragging {
            minOffset -= 36
            maxOffset += 36
        }
        
        return max(min(offset, maxOffset), minOffset)
    }
    
    private func getTotalWidthOfEachImage(for geometry: GeometryProxy) -> CGFloat {
        let widthOfEachImage = self.getImageSize(for: geometry).width
        let insetForEachImage = 2 * (self.imageInset ?? 0)
        return widthOfEachImage + insetForEachImage
    }
    
    private func getNewTranslationWidth(for value: DragGesture.Value) -> CGFloat {
        value.translation.width - self.lastTranslationWidth
    }
}
