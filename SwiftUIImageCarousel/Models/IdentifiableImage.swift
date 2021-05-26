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
}
