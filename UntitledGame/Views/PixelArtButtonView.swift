//
//  PixelArtButtonView.swift
//  UntitledGame
//
//  Created by Maya Navarrete Moncada on 13/12/23.
//

import SwiftUI

struct PixelArtButtonView: View {
    var buttonImage: String
    var pressedImage: String
    var buttonPressedAction: (() -> Void)?
    @State private var isPressed: Bool = false
    var textView: Text?
    var textColor: Color?
    
    var body: some View {
        ZStack {
            Image(isPressed ? pressedImage : buttonImage)
                .interpolation(.none)
                .resizable()
            if let textView {
                textView                    
                    .offset(y: isPressed ? -2 : -7)
                    .opacity(isPressed ? 0.5 : 1)
                
            }
        }
        .foregroundStyle(textColor ?? .white).gesture(DragGesture(minimumDistance: 0).onChanged { _ in
            isPressed = true
        }.onEnded{ _ in
            isPressed = false
            buttonPressedAction?()
        }
        )
        
    }
}

#Preview {
    PixelArtButtonView(buttonImage: "ButtonPlay1", pressedImage: "ButtonPlay2")
}
