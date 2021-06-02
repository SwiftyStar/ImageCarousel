//
//  ImageCarouselViewModel.swift
//  SwiftUIImageCarousel
//
//  Created by Jacob Starry on 5/16/21.
//

import SwiftUI

struct ImageCarouselViewModel {
        
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
    
    func getDragValue(for dragValue: DragGesture.Value, lastOffset: CGFloat, carouselDragValue: CarouselDragValue, imageCount: Int, geometry: GeometryProxy, imageDimensions: ImageDimensions) -> CarouselDragValue {
        let newOffset = lastOffset + dragValue.translation.width
        let fullImageWidth = self.getFullImageWidth(for: geometry, imageDimensions: imageDimensions)
        
        let constrainedOffset = self.getConstrainedOffset(newOffset,
                                                          imageCount: imageCount,
                                                          fullImageWidth: fullImageWidth,
                                                          isDragging: true)
        
        let imageIndex = self.getImageIndex(for: constrainedOffset,
                                            fullImageWidth: fullImageWidth,
                                            imageCount: imageCount)
        
        return CarouselDragValue(offset: constrainedOffset,
                                 imageIndex: imageIndex,
                                 dragStartDate: carouselDragValue.dragStartDate ?? dragValue.time)
    }
    
    func getFinalDragValue(for dragValue: DragGesture.Value, carouselDragValue: CarouselDragValue, lastIndex: Int, geometry: GeometryProxy, imageCount: Int, imageDimensions: ImageDimensions) -> CarouselDragValue {
        let fullImageWidth = self.getFullImageWidth(for: geometry, imageDimensions: imageDimensions)
        let safeWidth = max(fullImageWidth, 1) // Avoid division by 0 for edge cases
        
        let numberOfImagesScrolled = carouselDragValue.offset / safeWidth
        let roundedNumberOfImages = round(Double(numberOfImagesScrolled))
        let finalScrolledOffset = CGFloat(roundedNumberOfImages) * fullImageWidth
        
        let currentScrolledOffset = self.getConstrainedOffset(finalScrolledOffset,
                                                              imageCount: imageCount,
                                                              fullImageWidth: fullImageWidth,
                                                              isDragging: false)
        
        let scrolledImageIndex = self.getImageIndex(for: currentScrolledOffset,
                                                    fullImageWidth: fullImageWidth,
                                                    imageCount: imageCount)
                
        return self.getFinalValueConsideringVelocity(dragValue: dragValue,
                                                     carouselDragValue: carouselDragValue,
                                                     lastIndex: lastIndex,
                                                     currentScrolledOffset: currentScrolledOffset,
                                                     scrolledImageIndex: scrolledImageIndex,
                                                     imageCount: imageCount,
                                                     fullImageWidth: fullImageWidth)
    }
    
    private func getFinalValueConsideringVelocity(dragValue: DragGesture.Value, carouselDragValue: CarouselDragValue, lastIndex: Int, currentScrolledOffset: CGFloat, scrolledImageIndex: Int, imageCount: Int, fullImageWidth: CGFloat) -> CarouselDragValue {
        let finalOffset: CGFloat
        let finalIndex: Int
        let threshold: CGFloat = 500
        let velocity = self.getDragVelocity(dragValue, dragStartDate: carouselDragValue.dragStartDate)
        
        if scrolledImageIndex != lastIndex {
            finalOffset = currentScrolledOffset
            finalIndex = scrolledImageIndex
        } else if velocity < -threshold {
            let nextIndex = carouselDragValue.imageIndex + 1
            let maxIndex = imageCount - 1
            let constrainedNextIndex = min(nextIndex, maxIndex)
            let offset = -(CGFloat(constrainedNextIndex) * fullImageWidth)
            
            finalIndex = constrainedNextIndex
            finalOffset = self.getConstrainedOffset(offset,
                                                    imageCount: imageCount,
                                                    fullImageWidth: fullImageWidth,
                                                    isDragging: false)
        } else if velocity > threshold {
            let previousIndex = carouselDragValue.imageIndex - 1
            let constrainedPreviousIndex = max(previousIndex, 0)
            let offset = -(CGFloat(constrainedPreviousIndex) * fullImageWidth)
            
            finalIndex = constrainedPreviousIndex
            finalOffset = self.getConstrainedOffset(offset,
                                                    imageCount: imageCount,
                                                    fullImageWidth: fullImageWidth,
                                                    isDragging: false)
        } else {
            finalOffset = currentScrolledOffset
            finalIndex = carouselDragValue.imageIndex
        }
        
        return CarouselDragValue(offset: finalOffset, imageIndex: finalIndex, dragStartDate: nil)
    }
    
    private func getDragVelocity(_ value: DragGesture.Value, dragStartDate: Date?) -> CGFloat {
        guard let dragStart = dragStartDate else { return 0 }
        
        let timeDifference = abs(value.time.distance(to: dragStart))
        let width = value.translation.width
        
        return width / CGFloat(timeDifference)
    }
    
    private func getImageIndex(for offset: CGFloat, fullImageWidth: CGFloat, imageCount: Int) -> Int {
        let safeWidth = max(fullImageWidth, 1) // Avoid division by 0
        let numberOfImagesScrolled = -offset / safeWidth // Scrolling forward gives negative offset
        let index = Int(round(Double(numberOfImagesScrolled)))
        let maxIndex = imageCount - 1
        let constrainedIndex = min(max(index, 0), maxIndex)
        
        return constrainedIndex
    }
    
    private func getConstrainedOffset(_ offset: CGFloat, imageCount: Int, fullImageWidth: CGFloat, isDragging: Bool) -> CGFloat {
        let maxImagesToBeOffset = imageCount - 1 // If we offset N - 1 images, then the last will be visible
        
        var minOffset = -(fullImageWidth * CGFloat(maxImagesToBeOffset))
        var maxOffset = CGFloat.zero
        
        if isDragging {
            minOffset -= 36
            maxOffset += 36
        }
        
        return max(min(offset, maxOffset), minOffset)
    }
    
    private func getFullImageWidth(for geometry: GeometryProxy, imageDimensions: ImageDimensions) -> CGFloat {
        let widthOfEachImage = self.getImageSize(for: geometry, imageDimensions: imageDimensions).width
        let insetForEachImage = 2 * (imageDimensions.inset ?? 0)
        return widthOfEachImage + insetForEachImage
    }
}
