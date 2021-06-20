//
//  ExampleScreenViewModel.swift
//  SwiftUIImageCarousel
//
//  Created by Jacob Starry on 5/24/21.
//

import SwiftUI

final class ExampleScreenViewModel: ObservableObject {
    private let mockImages = ImageResponse.mock // Image names/URLs we've already retrieved from the API
    private let imageThreshold = 2 // Load images in advance
    private let semaphore = DispatchSemaphore(value: 1)
    
    @Published var loadedImages: [Image] = []
    private var indexToLoad = 0
    
    func getImageCount() -> Int {
        self.mockImages.imageNames.count
    }
    
    func lazyLoadImages(currentImage: Int) {
        let imagesToLoad = self.imagesToLoad(for: currentImage)
        guard imagesToLoad > 0 else { return }
        
        self.getImages(count: imagesToLoad)
    }
    
    private func imagesToLoad(for currentImage: Int) -> Int {
        var newMaxImageIndex = currentImage + self.imageThreshold
        guard newMaxImageIndex >= self.indexToLoad,
              self.indexToLoad < self.getImageCount()
        else { return 0 }

        var imagesToLoad = 0
        
        while newMaxImageIndex >= self.indexToLoad {
            if newMaxImageIndex < self.getImageCount() {
                imagesToLoad += 1
            }
            
            newMaxImageIndex -= 1
        }
        
        return imagesToLoad
    }
    
    private func getImages(count: Int) {
        DispatchQueue.global(qos: .userInteractive).async {
            for _ in 0..<count {
                let nextImageIndex = self.indexToLoad
                self.indexToLoad += 1
                guard nextImageIndex < self.getImageCount() else { return }
                
                self.mockLoadingImage(for: nextImageIndex)
            }
        }
    }
    
    private func mockLoadingImage(for index: Int) {
        self.semaphore.wait()
        let randomTime = TimeInterval.random(in: 1.0...2.0)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + randomTime) {
            let nextImageName = self.mockImages.imageNames[index]
            self.loadedImages.append(Image(nextImageName))
            self.semaphore.signal()
        }
    }
}
