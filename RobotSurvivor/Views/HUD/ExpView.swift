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
    @ObservedObject var gameLogic = GameLogic.shared
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
                            Text("\(gameLogic.playerLevel)")
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
                                .frame(width: ((geometry.size.width - levelChipSize)/CGFloat(gameLogic.xpToNextLvl)) * (gameLogic.playerLevel == 1 ? CGFloat(Double(gameLogic.currentXP) * 2.45) : CGFloat(gameLogic.currentXP)), height: levelChipSize)
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
    ExpView()
}
