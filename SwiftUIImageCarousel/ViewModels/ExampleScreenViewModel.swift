//
//  ExampleScreenViewModel.swift
//  SwiftUIImageCarousel
//
//  Created by Jacob Starry on 5/24/21.
//

import SwiftUI

final class ExampleScreenViewModel {
    typealias ImageLoadCompletion = ([IdentifiableImage]) -> Void
    
    private let mockImages = ImageResponse.mock // Image names/URLs we've already retrieved from the API
    private let threshold = 2 // Load 2 images in advance
    private let dispatchGroup = DispatchGroup()

    private var loadedImages: [IdentifiableImage] = []
    
    func getImageCount() -> Int {
        self.mockImages.imageNames.count
    }
    
    func lazyLoadImages(currentImage: Int, onLoad: @escaping ImageLoadCompletion) {
        let newMaxImage = currentImage + self.threshold
        let imagesToLoad = self.imagesToLoad(for: currentImage)
        
        guard newMaxImage > self.loadedImages.count,
              imagesToLoad > 0
        else { return }

        self.getImages(count: imagesToLoad, completion: onLoad)
    }
    
    private func imagesToLoad(for currentImage: Int) -> Int {
        var newMaxImage = currentImage + self.threshold
        let lastLoadedImage = self.loadedImages.count - 1
        guard self.loadedImages.count < self.getImageCount() else { return 0 }
        
        var imagesToLoad = 0
        
        while newMaxImage > lastLoadedImage {
            if newMaxImage < self.getImageCount() {
                imagesToLoad += 1
            }
            
            newMaxImage -= 1
        }
        
        return imagesToLoad
    }
    
    private func getImages(count: Int, completion: @escaping ImageLoadCompletion) {
        for index in 0..<count {
            let nextImageIndex = self.loadedImages.count + index
            guard nextImageIndex < self.getImageCount() else { break }
            
            let nextImageName = self.mockImages.imageNames[nextImageIndex]

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.dispatchGroup.enter()
                                
                let nextImage = IdentifiableImage(image: Image(nextImageName))
                self.loadedImages.append(nextImage)
                completion(self.loadedImages)
                
                self.dispatchGroup.leave()
            }
        }
    }
}
