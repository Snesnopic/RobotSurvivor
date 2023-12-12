//
//  ParentView.swift
//  UntitledGame
//
//  Created by Linar Zinatullin on 07/12/23.
//

import SwiftUI

struct ParentView: View {
    
    @State var currentGameState: GameState = .mainScreen
    
    var body: some View {
        
        switch currentGameState {
        case .mainScreen: 
            MainMenuView(currentGameState: $currentGameState)
        case .playing:
            GameView()
        case .gameOver:
            EmptyView()
        }
        
    }
}


#Preview {
    ParentView()
}
