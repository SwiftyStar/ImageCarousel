//
//  ExampleScreenViewModel.swift
//  SwiftUIImageCarousel
//
//  Created by Jacob Starry on 5/24/21.
//

import SwiftUI

final class ExampleScreenViewModel {
    typealias ImageLoadCompletion = ([Image]) -> Void
    
    private let mockImages = ImageResponse.mock // Image names/URLs we've already retrieved from the API
    private let imageThreshold = 2 // Load images in advance
    private let semaphore = DispatchSemaphore(value: 1)
    private let dispatchGroup = DispatchGroup()
    private var loadedImages: [Image] = []
    private var indexToLoad = 0
    
    func getImageCount() -> Int {
        self.mockImages.imageNames.count
    }
    
    func lazyLoadImages(currentImage: Int, onLoad: @escaping ImageLoadCompletion) {
        let imagesToLoad = self.imagesToLoad(for: currentImage)
        guard imagesToLoad > 0 else { return }
        
        self.getImages(count: imagesToLoad, completion: onLoad)
    }
    
    private func imagesToLoad(for currentImage: Int) -> Int {
        var newMaxImageIndex = currentImage + self.imageThreshold
        guard self.indexToLoad < self.getImageCount() else { return 0 }
        
        var imagesToLoad = 0
        
        while newMaxImageIndex >= self.indexToLoad {
            if newMaxImageIndex < self.getImageCount() {
                imagesToLoad += 1
            }
            
            newMaxImageIndex -= 1
        }
        
        return imagesToLoad
    }
    
    private func getImages(count: Int, completion: @escaping ImageLoadCompletion) {
        DispatchQueue.global(qos: .userInteractive).async {
            for _ in 0..<count {
                let nextImageIndex = self.indexToLoad
                self.indexToLoad += 1
                guard nextImageIndex < self.getImageCount() else { return }
                
                self.mockLoadingImage(for: nextImageIndex, completion: completion)
            }
        }
    }
    
    private func mockLoadingImage(for index: Int, completion: @escaping ImageLoadCompletion) {
        self.semaphore.wait()
        let randomTime = TimeInterval.random(in: 1.0...2.0)
        
        DispatchQueue.global(qos: .userInteractive).asyncAfter(deadline: .now() + randomTime) {
            let nextImageName = self.mockImages.imageNames[index]
            self.loadedImages.append(Image(nextImageName))
            completion(self.loadedImages)
            self.semaphore.signal()
        }
    }
}
