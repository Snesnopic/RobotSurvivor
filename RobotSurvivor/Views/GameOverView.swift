//
//  GameOverView.swift
//  UntitledGame
//
//  Created by Linar Zinatullin on 07/12/23.
//

import SwiftUI

struct GameOverView: View {
    
    @Binding var currentGameState: GameState
    @Binding var score:Int
    @State var opacity: Double = 0
    
    var body: some View {
        ZStack{
            Color.darkGreen
                .ignoresSafeArea()
            VStack(){
                Text("Game")
                    .font(.custom("Silkscreen-Bold", size: 75))
                    .padding(.bottom, -50)
                Text("Over")
                    .font(.custom("Silkscreen-Bold", size: 75))
                    .padding(.bottom)
                Text("Score: \(score)")
                    .font(.custom("Silkscreen-Bold", size: 35))
                    .padding(.bottom)
                PixelArtButtonView(buttonImage: "ButtonPlay1", pressedImage: "ButtonPlay2",buttonPressedAction: {
                    //TODO: add navigation to settings
                    withAnimation{ restartGame()}
                   
                    
                }, textView: Text("Restart") .font(.custom("Silkscreen-Regular", size: 35)), textColor: .white)
                .frame(width: 228, height:96)
                .padding(.bottom, 5)
                .shadow(radius: 15)
                
                
                PixelArtButtonView(buttonImage: "ButtonSett1", pressedImage: "ButtonSett2", buttonPressedAction: {
                    //TODO: add navigation to settings
                    withAnimation{ backToMainScreen()}
                }, textView: Text("Menu").font(.custom("Silkscreen-Regular", size: 25)), textColor: .white)                
                .frame(width: 224, height:64)
            }
            .foregroundStyle(.green)
            
            
        }
        .opacity(opacity)
        .onAppear{
            withAnimation{
                opacity = 1
            }
            
        }
    }
    
    private func backToMainScreen() {
        print("backtoMain")
        self.currentGameState = .mainScreen
        
    }
    
    private func restartGame() {
        print("restart")
        self.currentGameState = .playing
        
    }
}

#Preview {
    GameOverView(currentGameState: .constant(GameState.gameOver), score: .constant(100))
}
