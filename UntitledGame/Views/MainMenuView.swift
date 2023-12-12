//
//  MainMenuView.swift
//  UntitledGame
//
//  Created by Linar Zinatullin on 07/12/23.
//

import SwiftUI

struct MainMenuView: View {
    @Binding var currentGameState: GameState
    
    
    var body: some View {
        ZStack{
            Color.darkGreen
                .ignoresSafeArea()
            
            VStack{
                
                Spacer()
                
                Image(systemName: "cpu")
                    .font(.system(size: 70))
                    .padding(.bottom, -20)
                    .foregroundColor(.green)
                
                Text("Robot")
                    .font(.custom("Silkscreen-Bold", size: 65))
                    .foregroundStyle(.green)
                Text("Survivor")
                    .font(.custom("Silkscreen-Bold", size: 39))
                    .foregroundStyle(.green)
                    .padding(.bottom, 75)
                
                Button(action: {
                    currentGameState = .playing
                }, label: {
                    Text("Play")
                })
                .font(.custom("Silkscreen-Regular", size: 50))
                .frame(width: 225, height:85)
                .background(RoundedRectangle(cornerRadius: 10.0).fill(.green.opacity(0.3)))
                .foregroundStyle(.green)
                
                .padding(.bottom)
                
                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                    Text("Settings")
                })
                .font(.custom("Silkscreen-Regular", size: 25))
                .frame(width: 225, height:50)
                .background(RoundedRectangle(cornerRadius: 10.0).fill(.green.opacity(0.3)))
                .foregroundStyle(.green)
                
                Spacer()
                
            }
        }
    }
}

//#Preview {
//    MainMenuView(currentGameState: )
//}
