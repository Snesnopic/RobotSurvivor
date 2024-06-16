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
                HStack(spacing: 0) {
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
                    ZStack {
                        Image("emptyBar")
                            .interpolation(.none)
                            .resizable()
                            .frame(height: levelChipSize)
                        HStack {
                            Image("Line")
                                .interpolation(.none)
                                .resizable()
                                .frame(width: ((geometry.size.width - levelChipSize)/CGFloat(experienceNeeded)) * (currentLevel == 1 ? CGFloat(Double(currentXP) * 2.45) : CGFloat(currentXP)), height: levelChipSize)
                            Spacer()
                        }

                        Image("border")
                            .interpolation(.none)
                            .resizable()
                            .frame(height: levelChipSize)

                    }
                }
            }
        }
    }
}

#Preview {
    ExpView(experienceNeeded: .constant(100), currentXP: .constant(40), currentLevel: .constant(1))
}
