//
//  ExpView.swift
//  UntitledGame
//
//  Created by Antonio Claudio Pepe on 12/12/23.
//

import Foundation
import SwiftUI
import SpriteKit

struct ExpView: View {
     @State var experience: Int // Bind this to your game's experience logic

    var body: some View {
        GeometryReader { geometry in
            Rectangle()
                .fill(Color.blue)
                .frame(width: geometry.size.width * CGFloat(experience), height: 40)
                .animation(.linear, value: experience)
        }
    }
}

#Preview {
    ExpView(experience: 1)
}

