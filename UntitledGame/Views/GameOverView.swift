//
//  GameOverView.swift
//  UntitledGame
//
//  Created by Linar Zinatullin on 07/12/23.
//

import SwiftUI

struct GameOverView: View {
    var body: some View {
        ZStack{
            Color.darkGreen
                .ignoresSafeArea()
            
            VStack{
                Text("Game")
                    .font(.custom("Silkscreen-Bold", size: 50))
                Text("Over")
                    .font(.custom("Silkscreen-Bold", size: 51))
            }
            .foregroundStyle(.green)
        }
    }
}

#Preview {
    GameOverView()
}
