//
//  ImageCarousel+Modifiers.swift
//  SwiftUIImageCarousel
//
//  Created by Jacob Starry on 5/19/21.
//

import SwiftUI

extension ImageCarousel {
    func imageDimensions(inset: CGFloat? = nil, width: CGFloat? = nil, aspectRatio: CGFloat? = nil) -> ImageCarousel {
        var mutable = self
        mutable.viewModel = ImageCarouselViewModel(imageInset: inset, imageWidth: width, aspectRatio: aspectRatio)
        return mutable
    }
    
    func onImageTap(_ action: ImageTapAction?) -> ImageCarousel {
        var mutable = self
        mutable.onImageTap = action
        return mutable
    }
}
