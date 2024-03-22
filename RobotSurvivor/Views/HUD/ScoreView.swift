//
//  ScoreView.swift
//  UntitledGame
//
//  Created by Linar Zinatullin on 07/12/23.
//

import SwiftUI

struct ScoreView: View {
    @StateObject var gameLogic: GameLogic =  GameLogic.shared
    @Binding var score: Int
    @Binding var time: TimeInterval
    
    var body: some View {
        GeometryReader{ geometry in
            Group {
                Text("score")
                    .font(.custom("Silkscreen-Regular", size: 30))
                    .foregroundStyle(.white)
                .position(CGPoint(x: geometry.size.width/2, y: 60))
            
            Text(String(score))
                .font(.custom("Silkscreen-Regular", size: 30))
                .foregroundStyle(.white)
                .position(CGPoint(x: geometry.size.width/2, y: 90))
            
            Button(action: {
                gameLogic.showPauseMenu = true
            }, label: {
                Text("II")
                    .font(.custom("Silkscreen-Regular", size: 50))
                    .foregroundStyle(.white)
                    .padding(.bottom, 3)
                
            })
            .disabled(gameLogic.showPowerUp || gameLogic.showPauseMenu)
            .position(CGPoint(x: geometry.size.width - 60, y: 75) )
            .frame(width: 40, height: 40, alignment: .center)
                        
            Text("Time")
                .font(.custom("Silkscreen-Regular", size: 30))
                .foregroundStyle(.white)
                .position(CGPoint(x: geometry.size.width/6.5, y: 60) )
            Text(String(time.minuteSecond))
                .font(.custom("Silkscreen-Regular", size: 30))
                .foregroundStyle(.white)
                .position(CGPoint(x: geometry.size.width/6.5 , y: 90))
            }
            .offset(x: 7)
            
        }
        
    }
}

#Preview {
    ScoreView(score: .constant(100), time: .constant(TimeInterval(581)))
        .background {
            Color.black
        }
}
