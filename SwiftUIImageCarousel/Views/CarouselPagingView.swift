//
//  CarouselPagingView.swift
//  SwiftUIImageCarousel
//
//  Created by Jacob Starry on 5/19/21.
//

import SwiftUI

struct CarouselPagingView: View {
    @Binding var carouselDragValue: CarouselDragValue
    let totalImages: Int
    
    private let circleDiameter: CGFloat = 8
    
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
            ForEach(0..<self.totalImages) { index in
                Group {
                    if self.isSelected(index) {
                        self.selectedCircle
                    } else {
                        self.unselectedCircle
                    }
                    
                    if !self.isLastImage(index) {
                        Spacer()
                            .frame(width: 8)
                    }
                }
            }
        }
    }
    
    private func isSelected(_ index: Int) -> Bool {
        return index == self.carouselDragValue.imageIndex
    }
    
    private func isLastImage(_ index: Int) -> Bool {
        let lastIndex = self.totalImages - 1
        return index == lastIndex
    }
}

struct CarouselPagingView_Previews: PreviewProvider {
    static var previews: some View {
        CarouselPagingView(carouselDragValue: .constant(CarouselDragValue(offset: 0, imageIndex: 0, dragStartDate: nil)), totalImages: 3)
    }
}
