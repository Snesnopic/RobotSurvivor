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
    
    @Environment(GameLogic.self)
    var gameLogic: GameLogic
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Rectangle()
                    .fill(Color.green)
                    .frame(width: (geometry.size.width/CGFloat(gameLogic.xpToNextLvl)) * CGFloat(gameLogic.currentXP), height: 40)
                    .opacity(0.8)
            }
        }
        
        
    }
    

    
    
}

//#Preview {
//    ExpView(experienceNeeded: 20, currentXP: 0)
//}

