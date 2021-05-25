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
        
        
        VStack {
            let aspectRatio: CGFloat = 4 / 3
            ImageCarousel(images: .constant(IdentifiableImage.testImages))
                .onImageTap { print($0) }
                .imageDimensions(inset: 8, aspectRatio: aspectRatio)
                .hasPaging(true)
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
