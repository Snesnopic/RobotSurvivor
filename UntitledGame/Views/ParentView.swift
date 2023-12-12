//
//  ParentView.swift
//  UntitledGame
//
//  Created by Linar Zinatullin on 07/12/23.
//

import SwiftUI

struct ParentView: View {
    
    @State var currentGameState: GameState = .mainScreen
    
    @StateObject var gameLogic: GameLogic = GameLogic()
    
    var body: some View {
        
        switch currentGameState {
        case .mainScreen: 
            MainMenuView(currentGameState: $currentGameState)
        case .playing:
            GameView()
                .environmentObject(gameLogic)
        case .gameOver:
            EmptyView()
        }
        
    }
}


#Preview {
    ParentView()
}
