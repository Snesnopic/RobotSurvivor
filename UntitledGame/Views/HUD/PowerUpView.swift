//
//  PowerUpView.swift
//  UntitledGame
//
//  Created by Giuseppe Casillo on 12/12/23.
//

import Foundation
import SwiftUI
import SpriteKit

struct PowerUpView: View {
    @StateObject var gameLogic: GameLogic =  GameLogic.shared
    var body: some View {
        HStack{
            //TODO: randomly sort powerUp + give it to player on tap
            Button(action: {
                gameLogic.showPowerUp = false
            }, label: {
                Rectangle().frame(width: 100, height: 100).foregroundStyle(.green)
            })
            Button(action: {
                gameLogic.showPowerUp = false
            }, label: {
                Rectangle().frame(width: 100, height: 100).foregroundStyle(.green)
            }).padding(.horizontal)
            Button(action: {
                gameLogic.showPowerUp = false
            }, label: {
                Rectangle().frame(width: 100, height: 100).foregroundStyle(.green)
            })
        }
    }
}

#Preview {
    PowerUpView()
}
