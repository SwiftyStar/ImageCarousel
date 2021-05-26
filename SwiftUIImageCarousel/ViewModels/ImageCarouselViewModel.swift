//
//  ImageCarouselViewModel.swift
//  SwiftUIImageCarousel
//
//  Created by Jacob Starry on 5/16/21.
//

import SwiftUI

final class ImageCarouselViewModel {
        
    func getImageSize(for geometry: GeometryProxy, imageDimensions: ImageDimensions) -> CGSize {
        let totalInset = 2 * (imageDimensions.inset ?? 0)
        let defaultWidth = geometry.size.width - totalInset
        let width = imageDimensions.width ?? defaultWidth
        
        let maxHeight = geometry.size.height
        let height: CGFloat
        if let ratio = imageDimensions.aspectRatio {
            let proposedHeight = width / ratio
            let safeHeight = min(maxHeight, proposedHeight)
            height = safeHeight
        } else {
            height = maxHeight
        }
        
        return CGSize(width: width, height: height)
    }
    
    func getDragValue(for dragValue: DragGesture.Value, currentOffset: CGFloat, lastTranslation: CGFloat, imageCount: Int, geometry: GeometryProxy, imageDimensions: ImageDimensions) -> CarouselDragValue {
        let newTranslationWidth = self.getNewTranslationWidth(for: dragValue, lastTranslation: lastTranslation)
        
        let newOffset = currentOffset + newTranslationWidth
        let constrainedOffset = self.getConstrainedOffset(newOffset,
                                                          imageCount: imageCount,
                                                          geometry: geometry,
                                                          imageDimensions: imageDimensions,
                                                          isDragging: true)
        let currentImage = self.getCurrentImage(for: constrainedOffset,
                                                geometry: geometry,
                                                imageDimensions: imageDimensions)
        
        return CarouselDragValue(offset: constrainedOffset, currentImage: currentImage)
    }
    
    func getFinalDragValue(for dragValue: DragGesture.Value, scrollOffset: CGFloat, lastTranslation: CGFloat, geometry: GeometryProxy, imageCount: Int, imageDimensions: ImageDimensions) -> CarouselDragValue {
        let totalWidthOfEachImage = self.getTotalWidthOfEachImage(for: geometry, imageDimensions: imageDimensions)
        let safeWidth = max(totalWidthOfEachImage, 1) // Avoid division by 0 for edge cases
        let finalTranslationWidth = self.getNewTranslationWidth(for: dragValue, lastTranslation: lastTranslation)
        
        let finalScrollOffset = scrollOffset + finalTranslationWidth
        let numberOfImagesScrolled = finalScrollOffset / safeWidth
        let roundedNumberOfImages = round(Double(numberOfImagesScrolled))
        let totalOffset = CGFloat(roundedNumberOfImages) * totalWidthOfEachImage
        
        let constrainedOffset = self.getConstrainedOffset(totalOffset,
                                                          imageCount: imageCount,
                                                          geometry: geometry,
                                                          imageDimensions: imageDimensions,
                                                          isDragging: false)
        let currentImage = self.getCurrentImage(for: constrainedOffset,
                                                geometry: geometry,
                                                imageDimensions: imageDimensions)
        
        return CarouselDragValue(offset: constrainedOffset, currentImage: currentImage)
    }
    
    private func getCurrentImage(for offset: CGFloat, geometry: GeometryProxy, imageDimensions: ImageDimensions) -> Int {
        let totalWidthOfEachImage = self.getTotalWidthOfEachImage(for: geometry, imageDimensions: imageDimensions)
        let safeWidth = max(totalWidthOfEachImage, 1) // Avoid division by 0
        let numberOfImagesScrolled = -offset / safeWidth // Scrolling forward gives negative offset
        return Int(round(Double(numberOfImagesScrolled)))
    }
    
    private func getConstrainedOffset(_ offset: CGFloat, imageCount: Int, geometry: GeometryProxy, imageDimensions: ImageDimensions, isDragging: Bool) -> CGFloat {
        let totalWidthOfEachImage = self.getTotalWidthOfEachImage(for: geometry, imageDimensions: imageDimensions)
        let maxImagesToBeOffset = imageCount - 1 // If we offset N - 1 images, then the last will be visible
        
        var minOffset = -(totalWidthOfEachImage * CGFloat(maxImagesToBeOffset))
        var maxOffset = CGFloat.zero
        
        if isDragging {
            minOffset -= 36
            maxOffset += 36
        }
        
        return max(min(offset, maxOffset), minOffset)
    }
    
    private func getTotalWidthOfEachImage(for geometry: GeometryProxy, imageDimensions: ImageDimensions) -> CGFloat {
        let widthOfEachImage = self.getImageSize(for: geometry, imageDimensions: imageDimensions).width
        let insetForEachImage = 2 * (imageDimensions.inset ?? 0)
        return widthOfEachImage + insetForEachImage
    }
    
    private func getNewTranslationWidth(for value: DragGesture.Value, lastTranslation: CGFloat) -> CGFloat {
        return value.translation.width - lastTranslation
    }
}
