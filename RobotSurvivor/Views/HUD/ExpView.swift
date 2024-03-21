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
    @Binding var experienceNeeded: Int // Bind this to your game's experience logic
    @Binding var currentXP: Int
    @Binding var currentLevel: Int
    var levelChipSize = 50.0
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                HStack(spacing: 0){
                    Image("levelChip")
                        .interpolation(.none)
                        .resizable()
                        .scaledToFit()
                        .frame(width: levelChipSize, height: levelChipSize)
                        .overlay {
                            Text("\(currentLevel)")
                                .font(.custom("Silkscreen-Regular", size: 20))
                                .foregroundStyle(.white)
                        }
                    
                    Rectangle()
                        .fill(Color.green)
                        .frame(width: ((geometry.size.width - levelChipSize)/CGFloat(experienceNeeded)) * CGFloat(currentXP), height: levelChipSize)
                    .opacity(0.8)
                }
            }
        }
    }
}

#Preview {
    ExpView(experienceNeeded: .constant(40), currentXP: .constant(39), currentLevel: .constant(10))
}

