//
//  ContentView.swift
//  SwiftUIImageCarousel
//
//  Created by Jacob Starry on 5/13/21.
//

import SwiftUI

struct ExampleScreen: View {
    
    private var titleText: some View {
        Group {
            Spacer()
                .frame(height: 24)
            Text("Some Kitties")
            Spacer()
        }
    }
    
    var body: some View {
        let images = [Image("Kitten1"),
                      Image("Kitten2"),
                      Image("Kitten3"),
                      Image("Kitten4"),
                      Image("Kitten5")]
        let identifiableImages = images.map { IdentifiableImage(image: $0) }
        
        VStack {
            let aspectRatio: CGFloat = 4 / 3
            ImageCarousel(images: .constant(identifiableImages))
                .onImageTap { print($0) }
                .imageDimensions(inset: 8, aspectRatio: aspectRatio)
                .frame(height: UIScreen.main.bounds.width / aspectRatio)
            
            self.titleText
        }
    }
}

struct ExampleScreen_Previews: PreviewProvider {
    static var previews: some View {
        ExampleScreen()
    }
}
