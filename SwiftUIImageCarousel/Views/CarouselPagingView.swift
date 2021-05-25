//
//  CarouselPagingView.swift
//  SwiftUIImageCarousel
//
//  Created by Jacob Starry on 5/19/21.
//

import SwiftUI

struct CarouselPagingView: View {
    @Binding var images: [IdentifiableImage]
    @Binding var currentImage: Int
    
    private let circleDiameter: CGFloat = 10
    
    private var unselectedCircle: some View {
        Circle()
            .stroke(Color.gray)
            .frame(width: self.circleDiameter, height: self.circleDiameter)
    }
    
    private var selectedCircle: some View {
        Circle()
            .foregroundColor(Color.black)
            .frame(width: self.circleDiameter, height: self.circleDiameter)
    }
    
    var body: some View {
        HStack {
            ForEach(self.images) { image in
                Group {
                    if self.isSelected(image) {
                        self.selectedCircle
                    } else {
                        self.unselectedCircle
                    }
                    
                    if !self.isLastImage(image) {
                        Spacer()
                            .frame(width: 2)
                    }
                }
            }
        }
    }
    
    private func isSelected(_ image: IdentifiableImage) -> Bool {
        let currentImage = self.currentImage
        guard currentImage < self.images.count,
              currentImage >= 0
        else { return false }
        
        let selectedImage = self.images[self.currentImage]
        return image.id == selectedImage.id
    }
    
    private func isLastImage(_ image: IdentifiableImage) -> Bool {
        guard let lastImage = self.images.last else { return true }
        
        return image.id == lastImage.id
    }
}

struct CarouselPagingView_Previews: PreviewProvider {
    static var previews: some View {
        CarouselPagingView(images: .constant(IdentifiableImage.testImages), currentImage: .constant(0))
    }
}
