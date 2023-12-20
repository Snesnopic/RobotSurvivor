//
//  ScoreView.swift
//  UntitledGame
//
//  Created by Linar Zinatullin on 07/12/23.
//

import SwiftUI

struct ScoreView: View {
    
    @Environment(GameLogic.self)
    var gameLogic: GameLogic
    
    var body: some View {
        GeometryReader{ geometry in
             Text("score")
                .font(.custom("Silkscreen-Regular", size: 30))
                .foregroundStyle(.white)
                .position(CGPoint(x: geometry.size.width/2, y: 60) )
            Text(String(gameLogic.currentScore))
                .font(.custom("Silkscreen-Regular", size: 30))
                .foregroundStyle(.white)
                .position(CGPoint(x: geometry.size.width/2, y: 90) )
            
            Button(action: {
                gameLogic.showPauseMenu = true
            }, label: {
                Text("II")
                    .font(.custom("Silkscreen-Regular", size: 50))
                    .foregroundStyle(.white)
                    
                    
            })
            .disabled(gameLogic.showPowerUp || gameLogic.showPauseMenu)
            .position(CGPoint(x: geometry.size.width - 60, y: 75) )
            .frame(width: 40, height: 40, alignment: .center)
            
        }
    }
}

//#Preview {
//    ScoreView(score: .constant(100))
//}
