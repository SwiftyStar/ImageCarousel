//
//  ImageCarousel+Modifiers.swift
//  SwiftUIImageCarousel
//
//  Created by Jacob Starry on 5/19/21.
//

import SwiftUI

extension ImageCarousel {
    func withDimensions(inset: CGFloat? = nil, width: CGFloat? = nil, aspectRatio: CGFloat? = nil) -> ImageCarousel {
        var mutable = self
        let dimensions = ImageDimensions(width: width, inset: inset, aspectRatio: aspectRatio)
        mutable.imageDimensions = dimensions
        return mutable
    }
    
    func onImageTap(_ action: ImageTapAction?) -> ImageCarousel {
        var mutable = self
        mutable.onImageTap = action
        return mutable
    }
    
    func hasPaging(_ paging: Bool) -> ImageCarousel {
        var mutable = self
        mutable.hasPaging = paging
        return mutable
    }
}
