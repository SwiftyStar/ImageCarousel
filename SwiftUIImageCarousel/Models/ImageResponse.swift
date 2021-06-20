//
//  ImageResponse.swift
//  SwiftUIImageCarousel
//
//  Created by Jacob Starry on 5/24/21.
//

import Foundation

/// Represents API response
struct ImageResponse {
    let imageNames: [String] // Would likely be imageURLs instead
    
    static let mock: ImageResponse = {
        let names = ["Kitten1",
                     "Kitten2",
                     "Kitten3",
                     "Kitten4",
                     "Kitten5",
                     "Kitten1",
                     "Kitten2",
                     "Kitten3",
                     "Kitten4",
                     "Kitten5"
        ]
        
        return ImageResponse(imageNames: names)
    }()
}
