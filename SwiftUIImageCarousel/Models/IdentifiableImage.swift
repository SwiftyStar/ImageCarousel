//
//  IdentifiableImage.swift
//  SwiftUIImageCarousel
//
//  Created by Jacob Starry on 5/13/21.
//

import SwiftUI

struct IdentifiableImage: Identifiable {
    let id = UUID()
    let image: Image
    
    static let testImages: [IdentifiableImage] = {
        let images = [Image("Kitten1"),
                      Image("Kitten2"),
                      Image("Kitten3"),
                      Image("Kitten4"),
                      Image("Kitten5")]
        
        return images.map { IdentifiableImage(image: $0) }
    }()
}
