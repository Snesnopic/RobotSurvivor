//
//  UntitledGameApp.swift
//  UntitledGame
//
//  Created by Giuseppe Francione on 05/12/23.
//

import SwiftUI

@main
struct UntitledGameApp: App {
    
    @State var gameLogic: GameLogic = .shared
    
    var body: some Scene {
        WindowGroup {
            ParentView()
                .environment(gameLogic)
                .preferredColorScheme(.light)
        }
    }
}
