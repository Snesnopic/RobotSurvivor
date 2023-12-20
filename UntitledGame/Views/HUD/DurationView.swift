//
//  DurationView.swift
//  UntitledGame
//
//  Created by Linar Zinatullin on 07/12/23.
//

import SwiftUI

struct DurationView: View {
    
    @Environment(GameLogic.self)
    var gameLogic: GameLogic
    
    var body: some View {
        GeometryReader{ geometry in
            Text("Time")
               .font(.custom("Silkscreen-Regular", size: 30))
               .foregroundStyle(.white)
               .position(CGPoint(x: geometry.size.width/6.5, y: 60) )
            Text(String(gameLogic.time.minuteSecond))
                .font(.custom("Silkscreen-Regular", size: 30))
                .foregroundStyle(.white)
                .position(CGPoint(x: geometry.size.width/6.5 , y: 90))
        }
    }
}
//#Preview {
//    DurationView()
//}
