//
//  ScoreView.swift
//  UntitledGame
//
//  Created by Linar Zinatullin on 07/12/23.
//

import SwiftUI

struct ScoreView: View {
    @Binding var score: Int
    var body: some View {
        GeometryReader{ geometry in
             Text("score")
                .font(.custom("Silkscreen-Regular", size: 30))
                .foregroundStyle(.white)
                .position(CGPoint(x: geometry.size.width/2, y: 60) )
            Text(String(score))
                .font(.custom("Silkscreen-Regular", size: 30))
                .foregroundStyle(.white)
                .position(CGPoint(x: geometry.size.width/2, y: 90) )
        }
    }
}

//#Preview {
//    ScoreView()
//}
